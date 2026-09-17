use std::env;
use std::path::{Path, PathBuf};

#[derive(Debug, Clone)]
pub struct ProjectPaths {
    pub root: PathBuf,
}

impl ProjectPaths {
    pub fn new(root: impl Into<PathBuf>) -> Self {
        Self { root: root.into() }
    }

    pub fn skidora_dir(&self) -> PathBuf {
        self.root.join(".skidora")
    }

    pub fn draft(&self) -> PathBuf {
        self.skidora_dir().join("draft.md")
    }

    pub fn recover(&self) -> PathBuf {
        self.skidora_dir().join("recover.md")
    }

    pub fn plan(&self) -> PathBuf {
        self.skidora_dir().join("plan.md")
    }

    pub fn graph(&self) -> PathBuf {
        self.skidora_dir().join("graph.md")
    }

    pub fn tools(&self) -> PathBuf {
        self.skidora_dir().join("tools")
    }

    pub fn slug(&self) -> String {
        slug_from_path(&self.root)
    }
}

pub fn slug_from_path(path: &Path) -> String {
    let name = path
        .file_name()
        .and_then(|s| s.to_str())
        .unwrap_or("project");
    let mut slug = String::new();
    let mut prev_hyphen = false;
    for ch in name.chars() {
        if ch.is_ascii_alphanumeric() {
            slug.push(ch.to_ascii_lowercase());
            prev_hyphen = false;
        } else if !prev_hyphen {
            slug.push('-');
            prev_hyphen = true;
        }
    }
    let slug = slug.trim_matches('-').to_string();
    if slug.is_empty() {
        "project".into()
    } else {
        slug
    }
}

pub fn default_skill_dir() -> PathBuf {
    if let Ok(home) = env::var("SKIDORA_HOME") {
        return PathBuf::from(home);
    }
    home_dir().join(".cursor/skills/skidora")
}

pub fn home_dir() -> PathBuf {
    env::var_os("HOME")
        .or_else(|| env::var_os("USERPROFILE"))
        .map(PathBuf::from)
        .unwrap_or_else(|| PathBuf::from("."))
}

#[derive(Debug, Clone)]
pub struct SkillPaths {
    pub root: PathBuf,
}

impl SkillPaths {
    pub fn new(root: impl Into<PathBuf>) -> Self {
        Self { root: root.into() }
    }

    pub fn default() -> Self {
        Self::new(default_skill_dir())
    }

    pub fn index(&self) -> PathBuf {
        self.root.join("memory/index.md")
    }

    pub fn project_prompt(&self, slug: &str) -> PathBuf {
        self.root.join("memory/projects").join(format!("{slug}.md"))
    }
}
