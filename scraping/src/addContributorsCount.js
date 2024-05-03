import {openCSVFile, writeCSVFile} from "./utils/fs.js";

export async function addContributorsCount(octokit, filename, exportFilename, start, count) {
  const raw = openCSVFile(`data/${filename}`);

  const data = raw.slice(start, count);

  for (const item of data) {
    let page = 1;
    let next = true;
    let i = 0;
    let contribCount = null;
    try {
      const results = []
      while (next && i < 10) {
        const res = await octokit.request(`GET /repos/{owner}/{repo}/contributors?page=${page}&per_page=100`, {
          owner: item.owner,
          repo: item.name,
          headers: {
            'X-GitHub-Api-Version': '2022-11-28'
          }
        })

        if (res.data.length < 100) {
          next = false;
        }

        results.push(...res.data);

        page++;
        i++;
      }

      contribCount = results.length === 1000 ? "1000+" : results.length
    } catch (err){
      console.error(`Error: ${item.owner}/${item.name}`)
    }

    item.contributors = contribCount;

    console.log("Edit:", item.nameWithOwner, contribCount);
  }

  writeCSVFile(exportFilename, data)
}