import {parse, stringify} from "csv/sync";
import {mkdirSync, readFileSync, writeFileSync} from "fs";
import {fileURLToPath, URL} from "node:url";

export function writeCSVFile(name, content) {
  const out = stringify(content, {
    header: true,
  });

  const dirname = fileURLToPath(new URL(`../../dist/export`, import.meta.url))
  const filename = fileURLToPath(new URL(`../../dist/export/${name}`, import.meta.url))

  mkdirSync(dirname, { recursive: true });
  writeFileSync(filename, out);
}

export function openCSVFile(path) {
  const filename = fileURLToPath(new URL(`../../../${path}`, import.meta.url));
  const input = readFileSync(filename, "utf-8");

 return parse(input, {
   columns: true,
   skip_empty_lines: true
 });
}