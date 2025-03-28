SELECT
    coalesce(json_agg ("root"), 3) AS "root"
FROM
    (
        SELECT
            row_to_json (
                (
                    SELECT
                        "_e"
                    FROM
                        (
                            SELECT
                                ("_root.base"."value") AS "value",
                                "_root.ar.root.tokens"."tokens" AS "tokens"
                        ) AS "_e"
                )
            ) AS "root"
        FROM
            (
                SELECT
                    *
                FROM
                    "public"."Utxo"
                WHERE
                    (("public"."Utxo"."address") = ((2)))
                LIMIT
                    4
            ) AS "_root.base"
            LEFT OUTER JOIN LATERAL (
                SELECT
                    (
                        SELECT
                            coalesce(json_agg ("_sub_query"."tokens"), 5)
                        FROM
                            (
                                SELECT
                                    "_unnest_table"."tokens" AS "tokens"
                                FROM
                                    UNNEST (array_agg ("tokens")) AS "_unnest_table" ("tokens")
                                LIMIT
                                    6
                            ) AS "_sub_query"
                    ) AS "tokens"
                FROM
                    (
                        SELECT
                            row_to_json (
                                (
                                    SELECT
                                        "_e"
                                    FROM
                                        (
                                            SELECT
                                                "_root.ar.root.tokens.or.asset"."asset" AS "asset",
                                                ("_root.ar.root.tokens.base"."quantity") AS "quantity"
                                        ) AS "_e"
                                )
                            ) AS "tokens"
                        FROM
                            (
                                SELECT
                                    *
                                FROM
                                    "public"."TokenInOutput"
                                WHERE
                                    (("_root.base"."id") = ("tx_out_id"))
                            ) AS "_root.ar.root.tokens.base"
                            LEFT OUTER JOIN LATERAL (
                                SELECT
                                    row_to_json (
                                        (
                                            SELECT
                                                "_e"
                                            FROM
                                                (
                                                    SELECT
                                                        "_root.ar.root.tokens.or.asset.base"."assetId" AS "assetId",
                                                        "_root.ar.root.tokens.or.asset.base"."assetName" AS "assetName",
                                                        "_root.ar.root.tokens.or.asset.base"."decimals" AS "decimals",
                                                        "_root.ar.root.tokens.or.asset.base"."description" AS "description",
                                                        "_root.ar.root.tokens.or.asset.base"."fingerprint" AS "fingerprint",
                                                        "_root.ar.root.tokens.or.asset.base"."logo" AS "logo",
                                                        "_root.ar.root.tokens.or.asset.base"."metadataHash" AS "metadataHash",
                                                        "_root.ar.root.tokens.or.asset.base"."name" AS "name",
                                                        "_root.ar.root.tokens.or.asset.base"."ticker" AS "ticker",
                                                        "_root.ar.root.tokens.or.asset.ar.asset.tokenMints"."tokenMints" AS "tokenMints",
                                                        "_root.ar.root.tokens.or.asset.ar.asset.tokenMints_aggregate"."tokenMints_aggregate" AS "tokenMints_aggregate",
                                                        "_root.ar.root.tokens.or.asset.base"."url" AS "url",
                                                        "_root.ar.root.tokens.or.asset.base"."policyId" AS "policyId"
                                                ) AS "_e"
                                        )
                                    ) AS "asset"
                                FROM
                                    (
                                        SELECT
                                            *
                                        FROM
                                            "public"."Asset"
                                        WHERE
                                            (
                                                ("_root.ar.root.tokens.base"."assetId") = ("assetId")
                                            )
                                        LIMIT
                                            7
                                    ) AS "_root.ar.root.tokens.or.asset.base"
                                    LEFT OUTER JOIN LATERAL (
                                        SELECT
                                            (
                                                SELECT
                                                    coalesce(json_agg ("_sub_query"."tokenMints"), 8)
                                                FROM
                                                    (
                                                        SELECT
                                                            "_unnest_table"."tokenMints" AS "tokenMints"
                                                        FROM
                                                            UNNEST (array_agg ("tokenMints")) AS "_unnest_table" ("tokenMints")
                                                        LIMIT
                                                            9
                                                    ) AS "_sub_query"
                                            ) AS "tokenMints"
                                        FROM
                                            (
                                                SELECT
                                                    row_to_json (
                                                        (
                                                            SELECT
                                                                "_e"
                                                            FROM
                                                                (
                                                                    SELECT
                                                                        (
                                                                            "_root.ar.root.tokens.or.asset.ar.asset.tokenMints.base"."quantity"
                                                                        ) AS "quantity",
                                                                        "md5_a575e4a604d116b3fc884dfe8663955c__root.ar.root.tokens.or.asset.ar.asset.tokenMints.or.transaction"."transaction" AS "transaction"
                                                                ) AS "_e"
                                                        )
                                                    ) AS "tokenMints"
                                                FROM
                                                    (
                                                        SELECT
                                                            *
                                                        FROM
                                                            "public"."TokenMint"
                                                        WHERE
                                                            (
                                                                (
                                                                    ("_root.ar.root.tokens.or.asset.base"."policyId") = ("policyId")
                                                                )
                                                                AND (
                                                                    ("_root.ar.root.tokens.or.asset.base"."assetName") = ("assetName")
                                                                )
                                                            )
                                                    ) AS "_root.ar.root.tokens.or.asset.ar.asset.tokenMints.base"
                                                    LEFT OUTER JOIN LATERAL (
                                                        SELECT
                                                            row_to_json (
                                                                (
                                                                    SELECT
                                                                        "_e"
                                                                    FROM
                                                                        (
                                                                            SELECT
                                                                                "md5_872f05c33dfcdfab49cff39bb376ea51__root.ar.root.tokens.or.asset.ar.asset.tokenMints.or.transaction.base"."hash" AS "hash"
                                                                        ) AS "_e"
                                                                )
                                                            ) AS "transaction"
                                                        FROM
                                                            (
                                                                SELECT
                                                                    *
                                                                FROM
                                                                    "public"."Transaction"
                                                                WHERE
                                                                    (
                                                                        (
                                                                            "_root.ar.root.tokens.or.asset.ar.asset.tokenMints.base"."tx_id"
                                                                        ) = ("id")
                                                                    )
                                                                LIMIT
                                                                    10
                                                            ) AS "md5_872f05c33dfcdfab49cff39bb376ea51__root.ar.root.tokens.or.asset.ar.asset.tokenMints.or.transaction.base"
                                                    ) AS "md5_a575e4a604d116b3fc884dfe8663955c__root.ar.root.tokens.or.asset.ar.asset.tokenMints.or.transaction" ON (11)
                                            ) AS "_root.ar.root.tokens.or.asset.ar.asset.tokenMints"
                                    ) AS "_root.ar.root.tokens.or.asset.ar.asset.tokenMints" ON (12)
                                    LEFT OUTER JOIN LATERAL (
                                        SELECT
                                            json_build_object (
                                                13,
                                                json_build_object (
                                                    14,
                                                    COUNT(*),
                                                    15,
                                                    json_build_object (16, (max("quantity"))),
                                                    17,
                                                    json_build_object (18, (min("quantity"))),
                                                    19,
                                                    json_build_object (20, (sum("quantity")))
                                                )
                                            ) AS "tokenMints_aggregate"
                                        FROM
                                            (
                                                SELECT
                                                    "md5_843ce7ea17cf1db0c1a13c542e0f58fe__root.ar.root.tokens.or.asset.ar.asset.tokenMints_aggregate.base"."quantity" AS "quantity"
                                                FROM
                                                    (
                                                        SELECT
                                                            *
                                                        FROM
                                                            "public"."TokenMint"
                                                        WHERE
                                                            (
                                                                (
                                                                    ("_root.ar.root.tokens.or.asset.base"."policyId") = ("policyId")
                                                                )
                                                                AND (
                                                                    ("_root.ar.root.tokens.or.asset.base"."assetName") = ("assetName")
                                                                )
                                                            )
                                                    ) AS "md5_843ce7ea17cf1db0c1a13c542e0f58fe__root.ar.root.tokens.or.asset.ar.asset.tokenMints_aggregate.base"
                                            ) AS "_root.ar.root.tokens.or.asset.ar.asset.tokenMints_aggregate"
                                    ) AS "_root.ar.root.tokens.or.asset.ar.asset.tokenMints_aggregate" ON (21)
                            ) AS "_root.ar.root.tokens.or.asset" ON (22)
                    ) AS "_root.ar.root.tokens"
            ) AS "_root.ar.root.tokens" ON (23)
    ) AS "_root"