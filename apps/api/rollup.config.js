import path from "path";
import alias from "@rollup/plugin-alias";
import typescript from "@rollup/plugin-typescript";

const p = path.resolve(__dirname, "../../dist/libs/test-lib");

console.log(p);

module.exports = {
    input: "./src/app/index.ts",
    output: {
        dir: "dist",
        format: "cjs"
    },
    // preserveModules: true,
    plugins: [
        typescript(),
        alias({
            entries: {
                "@mattshardman/test-lib": p
            }
        })
    ]
};
