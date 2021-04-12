import { ApolloServer, gql, Config } from "apollo-server-lambda";

import { hello, goodbye } from "@mattshardman/test-lib";

const typeDefs = gql`
    type Query {
        hello: String
        goodbye: String
    }
`;

const resolvers = {
    Query: {
        hello: () => hello("you"),
        goodbye: () => goodbye("you")
    }
};

export const apolloConfig = {
    typeDefs,
    resolvers,
    playground: { endpoint: "/graphql" }
};

const server = new ApolloServer(apolloConfig);

export const handler = server.createHandler({
    cors: {
        origin:
            process.env.NODE_ENV === "production"
                ? "https://nxtest.vercel.app"
                : "*",
        credentials: true
    }
});

export default handler;
