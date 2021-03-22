import React from "react";
import { useQuery, gql } from "@apollo/client";

const QUERY = gql`
    query Hello {
        hello
    }
`;

const Index = () => {
    const { data, loading, error } = useQuery(QUERY);

    if (error) {
        return <div>Error</div>;
    }

    if (loading) {
        return <div>Loading...</div>;
    }

    return <div>{data?.hello}</div>;
};

export default Index;
