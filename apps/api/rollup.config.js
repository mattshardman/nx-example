import path from "path";
import alias from "@rollup/plugin-alias";
import typescript from "@rollup/plugin-typescript";

const testLibPath = path.resolve(__dirname, "../../dist/libs/test-lib");

module.exports = {
    input: "./src/app/index.ts",
    output: {
        dir: "dist/lambda",
        format: "cjs"
    },
    // preserveModules: true,
    plugins: [
        typescript(),
        alias({
            entries: {
                "@mattshardman/test-lib": testLibPath
            }
        })
    ]
};
