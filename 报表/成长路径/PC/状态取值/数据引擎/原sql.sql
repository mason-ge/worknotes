SELECT
	TBL.*
FROM
	(
		SELECT
			'0,1' AS CODE,
			'未开始' AS NAME
		FROM
			DUAL
		UNION ALL
			SELECT
				'2' AS CODE,
				'进行中' AS NAME
			FROM
				DUAL
			UNION ALL
				SELECT
					'3' AS CODE,
					'已通过' AS NAME
				FROM
					DUAL
	) TBL