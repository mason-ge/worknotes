SELECT
	TBL.*
FROM
	(
		SELECT
			TBB.all_user_month,
			TBB.cnt_all_user,
			TBB.cnt_all_content
		FROM
			(
				SELECT
					concat(
						YEAR (t.create_time),
						LPAD(MONTH(t.create_time), 2, 0)
					) AS all_user_month,
					count(DISTINCT t.create_user) AS cnt_all_user,
					count(t.content_id) as cnt_all_content
				FROM
					lecture_content t
				WHERE
					t.app_id = 'csb'
				AND t.create_time IS NOT NULL
				GROUP BY
					concat(
						YEAR (t.create_time),
						LPAD(MONTH(t.create_time), 2, 0)
					)
				ORDER BY
					CAST(
						concat(
							YEAR (t.create_time),
							LPAD(MONTH(t.create_time), 2, 0)
						) AS DECIMAL
					)
			) TBB
	) TBL