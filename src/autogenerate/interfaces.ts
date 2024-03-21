import { readdirSync, writeFileSync } from "fs"
import { parse } from "path"
import { compileFromFile } from 'json-schema-to-typescript'

const SCHEMA_DIRECTORY = "schemas"
const PACKAGE_DIRECTORY = "packages/schemas"

readdirSync(SCHEMA_DIRECTORY).forEach((file) => {
  compileFromFile(`${SCHEMA_DIRECTORY}/${file}`, {
    bannerComment: "/* eslint-disable */\n/**\n* This file was automatically generated.\n* Do not modify this file by hand.\n*/",
    additionalProperties: false
  })
    .then(ts => writeFileSync(`${PACKAGE_DIRECTORY}/${parse(file).name}.d.ts`, ts))
})
