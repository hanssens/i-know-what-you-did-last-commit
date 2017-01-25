import { autoinject } from 'aurelia-framework';
import { HttpClient } from 'aurelia-fetch-client';

@autoinject
export class App {
  message = 'Commits by Author';

  private token: string = 'access_token=<INSERT_TOKEN_HERE>';

  public company_name: string = 'MY_COMPANY';
  public username: string = 'MY_USERNAME';

  public repos: Array<GitHubRepo> = [];

  constructor(private http: HttpClient) {
  }

  public async gather() {

    // look into the localstorage to see if we have some cached results
    // we want to be sparse with our complimentary github-api limit, of course
    let cached = localStorage.getItem('repos');
    if (cached) {
      // if stuff is found in the cache, use it -- and quit it
      this.repos = JSON.parse(cached);
      return;
    }

    this.repos = [];

    // fetch all the repos that are in scope of the token
    // ideally, the token also allows access to private repos
    let response = await this.http.fetch(`https://api.github.com/orgs/${this.company_name}/repos?${this.token}`);
    let repositories = await response.json();

    repositories.forEach( async (repo) => {

      var r = new GitHubRepo();
      r.id = repo.id;
      r.name = repo.name;

      // for each repo, gather the commits for the specific *user*
      let commit_response = await this.http.fetch(`https://api.github.com/repos/${this.company_name}/${r.name}/commits?${this.token}`);
      let commit_result = await commit_response.json();

      commit_result.forEach( (commit) => {

        var c = new GitHubCommit();
        c.id = commit.sha;
        c.html_url = commit.html_url;
        c.message = commit.commit.message;
        c.when = commit.commit.author.date;

        r.commits.push(c);
      });

      this.repos.push(r);
    });

    // once we're done, persist it locally
    localStorage.setItem('repos', JSON.stringify(this.repos));

    console.log('repos: ', this.repos);
  }
}

export class GitHubRepo {
  public id: number;
  public name: string;
  public type: string;
  public commits: Array<GitHubCommit> = [];
}

export class GitHubCommit {
  public id: string;
  public author_name: string;
  public author_email: string;
  public when: Date;
  public message: string;
  public html_url: string;
}
