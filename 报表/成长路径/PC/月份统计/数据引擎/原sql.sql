SELECT
	TBL.*
FROM
	(
		SELECT
			TBA.checkpoint_month,
			TBB.cnt_all_user,
			TBB.cnt_in_user,
			TBB.cnt_pass_user,
			(
				CASE
				WHEN TBB.cnt_all_user = 0 THEN
					0
				ELSE
					round(
						TBB.cnt_in_user / TBB.cnt_all_user * 100,
						2
					)
				END
			) AS scale_in_user,
			(
				CASE
				WHEN TBB.cnt_all_user = 0 THEN
					0
				ELSE
					round(
						TBB.cnt_pass_user / TBB.cnt_all_user * 100,
						2
					)
				END
			) AS scale_pass_user
		FROM
			(
				SELECT
					concat(
						YEAR (t.create_time),
						LPAD(MONTH(t.create_time), 2, 0)
					) AS checkpoint_month
				FROM
					growup_checkpoint_detail t
				LEFT JOIN growup_checkpoint gc ON (
					t.checkpoint_id = gc.checkpoint_id
					AND t.app_id = gc.app_id
				)
				LEFT JOIN growup_path gp ON (
					t.growup_path_id = gp.growup_path_id
					AND t.app_id = gp.growup_path_id
				)
				WHERE
					t.create_time IS NOT NULL
				AND t.app_id = 'csb'
				GROUP BY
					concat(
						YEAR (t.create_time),
						LPAD(MONTH(t.create_time), 2, 0)
					)
				ORDER BY
					cast(
						concat(
							YEAR (t.create_time),
							LPAD(MONTH(t.create_time), 2, 0)
						) AS DECIMAL
					)
			) TBA
		LEFT JOIN (
			SELECT
				concat(
					YEAR (t.create_time),
					LPAD(MONTH(t.create_time), 2, 0)
				) AS all_user_month,
				count(DISTINCT t.user_id) AS cnt_all_user,
				count(
					DISTINCT (
						CASE
						WHEN t.checkpoint_flag IN ('2', '3') THEN
							t.user_id
						ELSE
							NULL
						END
					)
				) AS cnt_in_user,
				count(
					DISTINCT (
						CASE
						WHEN t.checkpoint_flag = '3' THEN
							t.user_id
						ELSE
							NULL
						END
					)
				) AS cnt_pass_user
			FROM
				growup_checkpoint_detail t
			LEFT JOIN growup_checkpoint gc ON (
				t.checkpoint_id = gc.checkpoint_id
				AND t.app_id = gc.app_id
			)
			LEFT JOIN growup_path gp ON (
				t.growup_path_id = gp.growup_path_id
				AND t.app_id = gp.growup_path_id
			)
			WHERE
				t.app_id = 'csb'
			GROUP BY
				concat(
					YEAR (t.create_time),
					LPAD(MONTH(t.create_time), 2, 0)
				)
		) TBB ON (
			TBB.all_user_month = TBA.checkpoint_month
		)
	) TBL