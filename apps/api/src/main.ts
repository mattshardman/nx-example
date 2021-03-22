import * as express from "express";
import { ApolloServer } from "apollo-server-express";
import { apolloConfig } from "./app";

const app = express();

const server = new ApolloServer(apolloConfig);
server.applyMiddleware({ app });

app.listen({ port: 3333 }, () =>
    console.log(`🚀 Server ready at http://localhost:3333${server.graphqlPath}`)
);
