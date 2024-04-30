import {stringify} from "csv/sync";
import {writeFileSync, mkdirSync} from "fs";
import {fileURLToPath, URL} from "node:url";

export function writeCSVFile(name, content) {
  const out = stringify(content, {
    header: true,
  });

  const dirname = fileURLToPath(new URL(`../../dist/export`, import.meta.url))
  const filename = fileURLToPath(new URL(`../../dist/export/${name}.csv`, import.meta.url))

  mkdirSync(dirname, { recursive: true });
  writeFileSync(filename, out);
}

export function openCSVFile(path) {
  const out = stringify(content, {
    header: true,
  });

  const dirname = fileURLToPath(new URL(`../../dist/export`, import.meta.url))
  const filename = fileURLToPath(new URL(`../../dist/export/${name}.csv`, import.meta.url))

  mkdirSync(dirname, { recursive: true });
  writeFileSync(filename, out);
}