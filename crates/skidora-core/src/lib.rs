mod error;
mod paths;
mod templates;

pub use error::{Error, Result};
pub use paths::{default_skill_dir, slug_from_path, ProjectPaths, SkillPaths};

use std::fs;
use std::path::{Path, PathBuf};

use chrono::Local;

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Bars {
    pub phase: String,
    pub done: String,
    pub blocked: String,
    pub next: String,
}

impl Default for Bars {
    fn default() -> Self {
        Self {
            phase: "clarify".into(),
            done: "—".into(),
            blocked: "—".into(),
            next: "load Helix and intake".into(),
        }
    }
}

impl Bars {
    pub fn render(&self) -> String {
        format!(
            "Phase: {}\nDone: {}\nBlocked: {}\nNext: {}",
            self.phase, self.done, self.blocked, self.next
        )
    }
}

#[derive(Debug, Clone)]
pub struct DraftEntry {
    pub phase: String,
    pub title: String,
    pub intent: String,
    pub did: String,
    pub evidence: String,
    pub open: String,
    pub timestamp: Option<String>,
}

#[derive(Debug, Clone)]
pub struct RecoverPrompt {
    pub slug: String,
    pub path: String,
    pub updated: String,
    pub goal: String,
    pub decisions: String,
    pub key_files: String,
    pub live_endpoints: String,
    pub nlp_map: String,
    pub next: String,
    pub open_risks: String,
}

impl RecoverPrompt {
    pub fn render(&self) -> String {
        format!(
            "# Recover prompt\n\nSlug: {slug}\nPath: {path}\nUpdated: {updated}\n\n## Goal\n{goal}\n\n## Decisions\n{decisions}\n\n## Key files\n{key_files}\n\n## Live endpoints\n{live_endpoints}\n\n## NLP map\n{nlp_map}\n\n## Next\n{next}\n\n## Open risks\n{open_risks}\n",
            slug = self.slug,
            path = self.path,
            updated = self.updated,
            goal = self.goal,
            decisions = dash_block(&self.decisions),
            key_files = dash_block(&self.key_files),
            live_endpoints = dash_block(&self.live_endpoints),
            nlp_map = dash_block(&self.nlp_map),
            next = self.next,
            open_risks = dash_block(&self.open_risks),
        )
    }
}

fn dash_block(value: &str) -> String {
    let trimmed = value.trim();
    if trimmed.is_empty() {
        return "- none".into();
    }
    if trimmed.starts_with('-') || trimmed.starts_with('#') {
        trimmed.to_string()
    } else {
        format!("- {trimmed}")
    }
}

pub fn now_stamp() -> String {
    Local::now().format("%Y-%m-%d %H:%M").to_string()
}

pub fn today() -> String {
    Local::now().format("%Y-%m-%d").to_string()
}

fn write_if_missing(path: &Path, body: &str) -> Result<()> {
    if path.exists() {
        return Ok(());
    }
    if let Some(parent) = path.parent() {
        fs::create_dir_all(parent)?;
    }
    fs::write(path, body)?;
    Ok(())
}

pub fn init_project(root: &Path) -> Result<ProjectPaths> {
    let paths = ProjectPaths::new(root);
    fs::create_dir_all(paths.skidora_dir())?;
    fs::create_dir_all(paths.tools())?;
    write_if_missing(&paths.draft(), templates::DRAFT)?;
    write_if_missing(&paths.plan(), templates::PLAN)?;
    let recover = templates::RECOVER
        .replace("{slug}", &paths.slug())
        .replace("{path}", &root.display().to_string())
        .replace("{updated}", &today());
    write_if_missing(&paths.recover(), &recover)?;
    let graph = templates::GRAPH
        .replace("{updated}", &today())
        .replace("{question}", "—");
    write_if_missing(&paths.graph(), &graph)?;
    Ok(paths)
}

pub fn parse_bars(text: &str) -> Bars {
    let mut bars = Bars::default();
    for line in text.lines() {
        if let Some(v) = line.strip_prefix("Phase:") {
            bars.phase = v.trim().to_string();
        } else if let Some(v) = line.strip_prefix("Done:") {
            bars.done = v.trim().to_string();
        } else if let Some(v) = line.strip_prefix("Blocked:") {
            bars.blocked = v.trim().to_string();
        } else if let Some(v) = line.strip_prefix("Next:") {
            bars.next = v.trim().to_string();
        }
    }
    bars
}

pub fn read_bars(root: &Path) -> Result<Bars> {
    let paths = ProjectPaths::new(root);
    if !paths.draft().exists() {
        return Err(Error::Missing(paths.draft()));
    }
    let text = fs::read_to_string(paths.draft())?;
    Ok(parse_bars(&text))
}

fn set_header_line(text: &str, key: &str, value: &str) -> String {
    let prefix = format!("{key}:");
    let mut replaced = false;
    let mut out = String::new();
    for line in text.lines() {
        if line.starts_with(&prefix) && !replaced {
            out.push_str(&format!("{key}: {value}\n"));
            replaced = true;
        } else {
            out.push_str(line);
            out.push('\n');
        }
    }
    if !replaced {
        format!("{key}: {value}\n{out}")
    } else {
        out
    }
}

pub fn append_draft(root: &Path, entry: &DraftEntry, bars: Option<&Bars>) -> Result<Bars> {
    let paths = init_project(root)?;
    let mut text = fs::read_to_string(paths.draft())?;
    let mut current = parse_bars(&text);
    if let Some(b) = bars {
        current = b.clone();
    } else {
        current.phase = entry.phase.clone();
        current.done = entry.title.clone();
    }
    text = set_header_line(&text, "Phase", &current.phase);
    text = set_header_line(&text, "Done", &current.done);
    text = set_header_line(&text, "Blocked", &current.blocked);
    text = set_header_line(&text, "Next", &current.next);
    let stamp = entry
        .timestamp
        .clone()
        .unwrap_or_else(now_stamp);
    let block = format!(
        "\n## [{stamp}] {phase} — {title}\n- Intent: {intent}\n- Did: {did}\n- Evidence: {evidence}\n- Open: {open}\n",
        phase = entry.phase,
        title = entry.title,
        intent = entry.intent,
        did = entry.did,
        evidence = if entry.evidence.is_empty() { "—" } else { &entry.evidence },
        open = if entry.open.is_empty() { "—" } else { &entry.open },
    );
    if !text.ends_with('\n') {
        text.push('\n');
    }
    text.push_str(&block);
    fs::write(paths.draft(), text)?;
    Ok(current)
}

pub fn read_recover(root: &Path) -> Result<String> {
    let paths = ProjectPaths::new(root);
    if !paths.recover().exists() {
        return Err(Error::Missing(paths.recover()));
    }
    Ok(fs::read_to_string(paths.recover())?)
}

pub fn write_recover(root: &Path, prompt: &RecoverPrompt) -> Result<PathBuf> {
    let paths = init_project(root)?;
    fs::write(paths.recover(), prompt.render())?;
    Ok(paths.recover())
}

pub fn write_graph(root: &Path, question: &str, updated: Option<&str>) -> Result<PathBuf> {
    let paths = init_project(root)?;
    let body = templates::GRAPH
        .replace("{updated}", updated.unwrap_or(&today()))
        .replace("{question}", question);
    fs::write(paths.graph(), body)?;
    Ok(paths.graph())
}

pub fn read_graph(root: &Path) -> Result<String> {
    let paths = ProjectPaths::new(root);
    if !paths.graph().exists() {
        return Err(Error::Missing(paths.graph()));
    }
    Ok(fs::read_to_string(paths.graph())?)
}

pub fn upsert_index(
    skill: &SkillPaths,
    slug: &str,
    path: &str,
    state: &str,
    updated: &str,
) -> Result<PathBuf> {
    let index_path = skill.index();
    if let Some(parent) = index_path.parent() {
        fs::create_dir_all(parent)?;
    }
    let mut text = if index_path.exists() {
        fs::read_to_string(&index_path)?
    } else {
        templates::INDEX.to_string()
    };
    let row = format!("| {slug} | {path} | {state} | {updated} |");
    let mut found = false;
    let mut lines: Vec<String> = Vec::new();
    for line in text.lines() {
        let is_row = line.starts_with('|')
            && !line.contains("---")
            && !line.to_ascii_lowercase().contains("| slug |");
        if is_row {
            let cells: Vec<&str> = line.split('|').map(|s| s.trim()).collect();
            if cells.get(1) == Some(&slug) {
                lines.push(row.clone());
                found = true;
                continue;
            }
        }
        lines.push(line.to_string());
    }
    text = lines.join("\n");
    if !text.ends_with('\n') {
        text.push('\n');
    }
    if !found {
        if !text.ends_with('\n') {
            text.push('\n');
        }
        text.push_str(&row);
        text.push('\n');
    }
    fs::write(&index_path, text)?;
    Ok(index_path)
}

pub fn save_global_recover(skill: &SkillPaths, prompt: &RecoverPrompt) -> Result<PathBuf> {
    let dest = skill.project_prompt(&prompt.slug);
    if let Some(parent) = dest.parent() {
        fs::create_dir_all(parent)?;
    }
    fs::write(&dest, prompt.render())?;
    upsert_index(
        skill,
        &prompt.slug,
        &prompt.path,
        prompt.goal.lines().next().unwrap_or("—"),
        &prompt.updated,
    )?;
    Ok(dest)
}

#[cfg(test)]
mod tests {
    use super::*;
    use tempfile::tempdir;

    #[test]
    fn slug_from_folder() {
        assert_eq!(slug_from_path(Path::new("/tmp/My App")), "my-app");
        assert_eq!(slug_from_path(Path::new("/tmp/skidora")), "skidora");
    }

    #[test]
    fn init_is_idempotent_and_creates_files() {
        let dir = tempdir().unwrap();
        init_project(dir.path()).unwrap();
        let draft = dir.path().join(".skidora/draft.md");
        fs::write(&draft, "keep me\nPhase: execute\n").unwrap();
        init_project(dir.path()).unwrap();
        let body = fs::read_to_string(&draft).unwrap();
        assert!(body.contains("keep me"));
        assert!(dir.path().join(".skidora/recover.md").exists());
        assert!(dir.path().join(".skidora/graph.md").exists());
        assert!(dir.path().join(".skidora/plan.md").exists());
        assert!(dir.path().join(".skidora/tools").is_dir());
    }

    #[test]
    fn draft_appends_and_updates_bars() {
        let dir = tempdir().unwrap();
        let entry1 = DraftEntry {
            phase: "execute".into(),
            title: "add cli".into(),
            intent: "build rust cli".into(),
            did: "crates/skidora-cli".into(),
            evidence: "cargo test".into(),
            open: "nvim".into(),
            timestamp: Some("2026-09-16 21:00".into()),
        };
        append_draft(dir.path(), &entry1, None).unwrap();
        let bars = read_bars(dir.path()).unwrap();
        assert_eq!(bars.phase, "execute");
        assert_eq!(bars.done, "add cli");
        let entry2 = DraftEntry {
            phase: "verify".into(),
            title: "recheck".into(),
            intent: "prove tests".into(),
            did: "cargo test".into(),
            evidence: "ok".into(),
            open: "—".into(),
            timestamp: Some("2026-09-16 21:05".into()),
        };
        append_draft(dir.path(), &entry2, None).unwrap();
        let text = fs::read_to_string(dir.path().join(".skidora/draft.md")).unwrap();
        assert!(text.contains("add cli"));
        assert!(text.contains("recheck"));
        assert!(text.contains("## [2026-09-16 21:00] execute — add cli"));
        let bars = read_bars(dir.path()).unwrap();
        assert_eq!(bars.phase, "verify");
    }

    #[test]
    fn recover_round_trip() {
        let dir = tempdir().unwrap();
        let prompt = RecoverPrompt {
            slug: "demo".into(),
            path: dir.path().display().to_string(),
            updated: "2026-09-16".into(),
            goal: "ship memory cli".into(),
            decisions: "rust core plus nvim shim".into(),
            key_files: "crates/skidora-core/src/lib.rs — memory".into(),
            live_endpoints: "none".into(),
            nlp_map: "recover -> skidora recover".into(),
            next: "wire nvim".into(),
            open_risks: "none".into(),
        };
        write_recover(dir.path(), &prompt).unwrap();
        let text = read_recover(dir.path()).unwrap();
        assert!(text.contains("Slug: demo"));
        assert!(text.contains("ship memory cli"));
        assert!(text.contains("wire nvim"));
    }

    #[test]
    fn graph_writes_question() {
        let dir = tempdir().unwrap();
        write_graph(dir.path(), "where is auth?", Some("2026-09-16")).unwrap();
        let text = read_graph(dir.path()).unwrap();
        assert!(text.contains("Question: where is auth?"));
        assert!(text.contains("## Nodes"));
        assert!(text.contains("## Edges"));
    }

    #[test]
    fn index_upsert_replaces_same_slug() {
        let dir = tempdir().unwrap();
        let skill = SkillPaths::new(dir.path());
        upsert_index(&skill, "skidora", "/tmp/a", "first", "2026-09-16").unwrap();
        upsert_index(&skill, "skidora", "/tmp/a", "second", "2026-09-17").unwrap();
        upsert_index(&skill, "other", "/tmp/b", "hi", "2026-09-17").unwrap();
        let text = fs::read_to_string(skill.index()).unwrap();
        assert_eq!(text.matches("| skidora |").count(), 1);
        assert!(text.contains("| skidora | /tmp/a | second | 2026-09-17 |"));
        assert!(text.contains("| other |"));
        let prompt = RecoverPrompt {
            slug: "skidora".into(),
            path: "/tmp/a".into(),
            updated: "2026-09-17".into(),
            goal: "tiny prompt".into(),
            decisions: "none".into(),
            key_files: "none".into(),
            live_endpoints: "none".into(),
            nlp_map: "none".into(),
            next: "done".into(),
            open_risks: "none".into(),
        };
        save_global_recover(&skill, &prompt).unwrap();
        let copied = fs::read_to_string(skill.project_prompt("skidora")).unwrap();
        assert!(copied.contains("tiny prompt"));
    }
}
