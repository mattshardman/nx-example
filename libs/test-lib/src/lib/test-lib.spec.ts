import { hello } from "./test-lib";

describe("testLib", () => {
    it("should work", () => {
        expect(hello("Matt")).toEqual("Hello Matt");
    });
});
