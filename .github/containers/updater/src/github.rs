pub static GITHUB_API_URL: &str = "https://api.github.com";
pub static GITHUB_API_ACCEPT: &str = "application/vnd.github.v3+json";

pub struct UreqGithubApi {
    token: String,
}

pub mod types;
pub use types::Release;

impl Default for UreqGithubApi {
    fn default() -> Self {
        let token = std::env::var("GITHUB_TOKEN").unwrap();
        let token = format!("token {}", token);
        Self { token }
    }
}

#[derive(Debug, Clone, Copy)]
pub struct Page {
    pub per_page: u32,
    pub page: u32,
}

impl Default for Page {
    fn default() -> Self {
        Self {
            per_page: 100,
            page: 1,
        }
    }
}

pub trait GithubApi {
    type Error;
    fn get_releases(
        &self,
        page: Page,
        owner: &str,
        repo: &str,
    ) -> Result<Vec<Release>, Self::Error>;
}

impl GithubApi for UreqGithubApi {
    type Error = Box<dyn std::error::Error>;
    fn get_releases(
        &self,
        page: Page,
        owner: &str,
        repo: &str,
    ) -> Result<Vec<Release>, Self::Error> {
        let url = format!(
            "{api_base}/repos/{owner}/{repo}/releases",
            api_base = GITHUB_API_URL,
            owner = owner,
            repo = repo
        );
        let resp: Vec<Release> = ureq::get(&url)
            .set("Authorization", &self.token)
            .set("Accept", GITHUB_API_ACCEPT)
            .query("per_page", page.per_page.to_string())
            .query("page", page.page.to_string())
            .call()?
            .into_json()?;
        Ok(resp)
    }
}
