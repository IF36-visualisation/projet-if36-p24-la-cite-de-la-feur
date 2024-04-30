import 'dotenv/config'
import {writeCSVFile} from "./utils/fs.js";

const token = process.env.GITHUB_TOKEN;

/*const octokit = new Octokit({
  auth: token,
});

const resp = await octokit.request(
  "GET /search/repositories?q=vue&sort=stars&order=desc",
  {
    headers: {
      "X-GitHub-Api-Version": "2022-11-28",
    },
  },
);

for (const item of resp.data.items) {
  await new Promise((resolve) => {
    setTimeout(
      async () => {
        const contributors = await octokit.request(
          `GET ${item.contributors_url}`,
          {
            headers: {
              "X-GitHub-Api-Version": "2022-11-28",
            },
          },
        );

        item.contributors = contributors.data;
        item.contributors_count = contributors.data.length;

        resolve();
      },
      Math.floor(Math.random() * 1000),
    );
  });
}
*/
function main() {
  writeCSVFile('test')
}


main();

