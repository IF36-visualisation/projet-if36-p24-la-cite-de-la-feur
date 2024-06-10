import 'dotenv/config'
import {addContributorsCount} from "./addContributorsCount.js";
import {Octokit} from "octokit";

const token = process.env.GITHUB_TOKEN;
const octokit = new Octokit({
  auth: token,
});

function main() {
  addContributorsCount(octokit, 'githubStar1-10/data_1.csv', 'data_3.csv', 301, 300);
  addContributorsCount(octokit, 'githubStar1-10/data_2.csv', 'data_4.csv', 301, 300);
}

main();
