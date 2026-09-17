use std::path::PathBuf;
use std::process::ExitCode;

use clap::{Parser, Subcommand};
use skidora_core::{
    append_draft, init_project, read_bars, read_graph, read_recover, save_global_recover, today,
    write_graph, write_recover, DraftEntry, ProjectPaths, RecoverPrompt, SkillPaths,
};

#[derive(Parser)]
#[command(
    name = "skidora",
    about = "Helix-style memory for Skidora projects",
    version
)]
struct Cli {
    /// Project root (defaults to current directory)
    #[arg(long, global = true)]
    path: Option<PathBuf>,

    /// Skill pack root for --global recover (defaults to $SKIDORA_HOME or ~/.cursor/skills/skidora)
    #[arg(long, global = true)]
    skill_dir: Option<PathBuf>,

    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// Create .skidora/ draft, recover, plan, graph, tools
    Init,
    /// Print Phase / Done / Blocked / Next
    Status,
    /// Append one Helix draft entry
    Draft {
        #[arg(long)]
        phase: String,
        #[arg(long)]
        title: String,
        #[arg(long)]
        intent: String,
        #[arg(long)]
        did: String,
        #[arg(long, default_value = "—")]
        evidence: String,
        #[arg(long, default_value = "—")]
        open: String,
        #[arg(long)]
        done: Option<String>,
        #[arg(long)]
        blocked: Option<String>,
        #[arg(long)]
        next: Option<String>,
    },
    /// Print or rewrite the tiny recover prompt
    Recover {
        #[arg(long)]
        goal: Option<String>,
        #[arg(long)]
        next: Option<String>,
        #[arg(long)]
        decisions: Option<String>,
        /// Also write memory/projects/<slug>.md and upsert the skill index
        #[arg(long)]
        global: bool,
    },
    /// Write or print Graphifier topology
    Graph {
        #[arg(long)]
        question: Option<String>,
    },
}

fn project_root(cli: &Cli) -> PathBuf {
    cli.path
        .clone()
        .unwrap_or_else(|| std::env::current_dir().expect("cwd"))
}

fn main() -> ExitCode {
    if let Err(err) = run() {
        eprintln!("{err}");
        return ExitCode::from(1);
    }
    ExitCode::SUCCESS
}

fn run() -> skidora_core::Result<()> {
    let cli = Cli::parse();
    let root = project_root(&cli);
    match cli.command {
        Commands::Init => {
            let paths = init_project(&root)?;
            println!("{}", paths.skidora_dir().display());
        }
        Commands::Status => {
            let bars = read_bars(&root)?;
            println!("{}", bars.render());
        }
        Commands::Draft {
            phase,
            title,
            intent,
            did,
            evidence,
            open,
            done,
            blocked,
            next,
        } => {
            let mut bars = if root.join(".skidora/draft.md").exists() {
                read_bars(&root).unwrap_or_default()
            } else {
                Default::default()
            };
            bars.phase = phase.clone();
            bars.done = done.unwrap_or_else(|| title.clone());
            if let Some(b) = blocked {
                bars.blocked = b;
            }
            if let Some(n) = next {
                bars.next = n;
            }
            let entry = DraftEntry {
                phase,
                title,
                intent,
                did,
                evidence,
                open,
                timestamp: None,
            };
            let bars = append_draft(&root, &entry, Some(&bars))?;
            println!("{}", bars.render());
        }
        Commands::Recover {
            goal,
            next,
            decisions,
            global,
        } => {
            let rewrite = goal.is_some() || next.is_some() || decisions.is_some();
            if rewrite {
                let paths = ProjectPaths::new(&root);
                let existing = read_recover(&root).unwrap_or_default();
                let prompt = RecoverPrompt {
                    slug: paths.slug(),
                    path: root.display().to_string(),
                    updated: today(),
                    goal: goal.unwrap_or_else(|| {
                        value_after(&existing, "## Goal").unwrap_or_else(|| "—".into())
                    }),
                    decisions: decisions.unwrap_or_else(|| "none".into()),
                    key_files: value_after(&existing, "## Key files")
                        .unwrap_or_else(|| ".skidora/draft.md — running Helix log".into()),
                    live_endpoints: value_after(&existing, "## Live endpoints")
                        .unwrap_or_else(|| "none".into()),
                    nlp_map: value_after(&existing, "## NLP map").unwrap_or_else(|| "none".into()),
                    next: next.unwrap_or_else(|| {
                        value_after(&existing, "## Next").unwrap_or_else(|| "—".into())
                    }),
                    open_risks: value_after(&existing, "## Open risks")
                        .unwrap_or_else(|| "none".into()),
                };
                write_recover(&root, &prompt)?;
                if global {
                    let skill = match &cli.skill_dir {
                        Some(dir) => SkillPaths::new(dir),
                        None => SkillPaths::default(),
                    };
                    save_global_recover(&skill, &prompt)?;
                }
            } else {
                init_project(&root)?;
                if global {
                    let paths = ProjectPaths::new(&root);
                    let skill = match &cli.skill_dir {
                        Some(dir) => SkillPaths::new(dir),
                        None => SkillPaths::default(),
                    };
                    let text = read_recover(&root)?;
                    let prompt = RecoverPrompt {
                        slug: paths.slug(),
                        path: root.display().to_string(),
                        updated: today(),
                        goal: value_after(&text, "## Goal").unwrap_or_else(|| "—".into()),
                        decisions: value_after(&text, "## Decisions").unwrap_or_else(|| "none".into()),
                        key_files: value_after(&text, "## Key files").unwrap_or_else(|| "none".into()),
                        live_endpoints: value_after(&text, "## Live endpoints")
                            .unwrap_or_else(|| "none".into()),
                        nlp_map: value_after(&text, "## NLP map").unwrap_or_else(|| "none".into()),
                        next: value_after(&text, "## Next").unwrap_or_else(|| "—".into()),
                        open_risks: value_after(&text, "## Open risks")
                            .unwrap_or_else(|| "none".into()),
                    };
                    save_global_recover(&skill, &prompt)?;
                }
            }
            print!("{}", read_recover(&root)?);
        }
        Commands::Graph { question } => {
            if let Some(q) = question {
                write_graph(&root, &q, None)?;
            } else {
                init_project(&root)?;
            }
            print!("{}", read_graph(&root)?);
        }
    }
    Ok(())
}

fn value_after(text: &str, heading: &str) -> Option<String> {
    let mut take = false;
    let mut buf = String::new();
    for line in text.lines() {
        if line.trim() == heading {
            take = true;
            continue;
        }
        if take && line.starts_with("## ") {
            break;
        }
        if take {
            buf.push_str(line);
            buf.push('\n');
        }
    }
    let v = buf.trim().to_string();
    if v.is_empty() {
        None
    } else {
        Some(v)
    }
}
