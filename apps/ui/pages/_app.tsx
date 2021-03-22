import React from "react";
import {
    ApolloProvider,
    ApolloClient,
    InMemoryCache,
    createHttpLink
} from "@apollo/client";
import { AppProps } from "next/app";
import Head from "next/head";
import "./styles.css";

const link = createHttpLink({
    uri:
        process.env.NODE_ENV === "production"
            ? "https://u7grf3xvd3.execute-api.eu-west-1.amazonaws.com/test/graphql"
            : "http://localhost:3333/graphql",
    credentials: "include"
});

const client = new ApolloClient({
    cache: new InMemoryCache(),
    link
});

function App({ Component, pageProps }: AppProps) {
    const [rendered, setRendered] = React.useState(false);

    React.useEffect(() => {
        setRendered(true);
    }, []);

    return (
        <ApolloProvider client={client}>
            <Head>
                <title>Welcome to ui!</title>
            </Head>
            <div className="app">
                {rendered && (
                    <main>
                        <Component {...pageProps} />
                    </main>
                )}
            </div>
        </ApolloProvider>
    );
}

export default App;
