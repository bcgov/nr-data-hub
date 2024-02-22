import { readdirSync, writeFileSync } from "fs"
import { parse } from "path"
import { compile, compileFromFile } from 'json-schema-to-typescript'

const SCHEMA_DIRECTORY = "schemas"
const PACKAGE_DIRECTORY = "packages/schemas"

readdirSync(SCHEMA_DIRECTORY).forEach((file) => {
  compileFromFile(`${SCHEMA_DIRECTORY}/${file}`, {
    bannerComment: "",
    additionalProperties: false
  })
    .then(ts => writeFileSync(`${PACKAGE_DIRECTORY}/${parse(file).name}.d.ts`, ts))
})
