SELECT
	TBL.*
FROM
	(
		SELECT
			TBA.create_month,
			TBP.cnt_people,
			TBPI.cnt_people_in,
			TBCP.cnt_pass,
			(
				CASE
				WHEN ifnull(TBP.cnt_people, 0) = 0 THEN
					0
				ELSE
					ROUND(
						ifnull(TBPI.cnt_people_in, 0) / ifnull(TBP.cnt_people, 0) * 100,
						2
					)
				END
			) AS scale_people,
			(
				CASE
				WHEN ifnull(TBPI.cnt_people_in, 0) = 0 THEN
					0
				ELSE
					ROUND(
						ifnull(TBCP.cnt_pass, 0) / ifnull(TBPI.cnt_people_in, 0) * 100,
						2
					)
				END
			) AS scale_pass
		FROM
			(
				SELECT
					concat(
						YEAR (t.create_time),
						LPAD(MONTH(t.create_time), 2, 0)
					) AS create_month
				FROM
					exam t
				WHERE
					1 = 1
				AND t.exam_type = '3'
				AND t.del_flag = '0'
				AND t.app_id = 'csb'
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
			) TBA
		LEFT JOIN (
			SELECT
				concat(
					YEAR (t.create_time),
					LPAD(MONTH(t.create_time), 2, 0)
				) AS people_month,
				count(
					DISTINCT eu.sys_user_id,
					eu.exam_id
				) AS cnt_people
			FROM
				exam_select_user eu
			LEFT JOIN exam t ON (
				eu.app_id = t.app_id
				AND eu.exam_id = t.exam_id
			)
			LEFT JOIN sys_user su ON (
				eu.sys_user_id = su.sys_user_id
				AND su.app_id = 'csb'
			)
			WHERE
				1 = 1
			AND eu.del_flag = '0'
			AND t.exam_type = '3'
			AND t.app_id = 'csb'
			AND t.del_flag = '0'
			AND eu.app_id = 'csb'
			GROUP BY
				concat(
					YEAR (t.create_time),
					LPAD(MONTH(t.create_time), 2, 0)
				)
		) TBP ON (
			TBP.people_month = TBA.create_month
		)
		LEFT JOIN (
			SELECT
				concat(
					YEAR (t.create_time),
					LPAD(MONTH(t.create_time), 2, 0)
				) AS people_in_month,
				count(
					DISTINCT eu.sys_user_id,
					eu.exam_id
				) AS cnt_people_in
			FROM
				exam_select_user eu
			LEFT JOIN sys_user su ON (
				eu.sys_user_id = su.sys_user_id
				AND su.app_id = 'csb'
			)
			INNER JOIN statistics s ON (
				eu.sys_user_id = s.sys_user_id
				AND eu.exam_id = s.exam_id
			)
			LEFT JOIN exam t ON (s.exam_id = t.exam_id)
			WHERE
				1 = 1
			AND eu.app_id = 'csb'
			AND t.exam_type = '3'
			AND t.app_id = 'csb'
			AND t.del_flag = '0'
			GROUP BY
				concat(
					YEAR (t.create_time),
					LPAD(MONTH(t.create_time), 2, 0)
				)
		) TBPI ON (
			TBPI.people_in_month = TBA.create_month
		)
		LEFT JOIN (
			SELECT
				concat(
					YEAR (t.create_time),
					LPAD(MONTH(t.create_time), 2, 0)
				) AS pass_month,
				count(
					CASE
					WHEN s.exam_pass_type = '9' THEN
						s.sid
					ELSE
						NULL
					END
				) AS cnt_pass
			FROM
				statistics s
			LEFT JOIN exam t ON (s.exam_id = t.exam_id)
			LEFT JOIN sys_user su ON (
				s.sys_user_id = su.sys_user_id
				AND su.app_id = 'csb'
			)
			WHERE
				1 = 1
			AND t.exam_type = '3'
			AND t.del_flag = '0'
			AND t.app_id = 'csb'
			GROUP BY
				concat(
					YEAR (t.create_time),
					LPAD(MONTH(t.create_time), 2, 0)
				)
		) TBCP ON (
			TBCP.pass_month = TBA.create_month
		)
	) TBL