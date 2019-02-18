SELECT
	TBL.*
FROM
	(
		SELECT
			TBB.all_user_month,
			(
				SELECT
					count(t.sys_user_id)
				FROM
					sys_user t
				WHERE
					t.app_id = 'csb'
				AND t.create_time IS NOT NULL
				AND concat(
					YEAR (t.create_time),
					LPAD(MONTH(t.create_time), 2, 0)
				) <= TBB.all_user_month
			) AS cnt_all_user,
			TBE.cnt_entry_user,
			TBR.cnt_leave_user
		FROM
			(
				SELECT
					concat(
						YEAR (t.create_time),
						LPAD(MONTH(t.create_time), 2, 0)
					) AS all_user_month,
					count(t.sys_user_id) AS cnt_all_user
				FROM
					sys_user t
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
		LEFT JOIN (
			SELECT
				concat(
					YEAR (t.entry_time),
					LPAD(MONTH(t.entry_time), 2, 0)
				) AS entry_month,
				count(t.sys_user_id) AS cnt_entry_user
			FROM
				sys_user t
			WHERE
				t.app_id = 'csb'
			AND t.entry_time IS NOT NULL
			GROUP BY
				concat(
					YEAR (t.entry_time),
					LPAD(MONTH(t.entry_time), 2, 0)
				)
		) TBE ON (
			TBB.all_user_month = TBE.entry_month
		)
		LEFT JOIN (
			SELECT
				concat(
					YEAR (r.leave_time),
					LPAD(MONTH(r.leave_time), 2, 0)
				) AS leave_month,
				count(r.user_id) AS cnt_leave_user
			FROM
				sys_user_leave_report r
			WHERE
				r.app_id = 'csb'
			AND r.leave_time IS NOT NULL
			GROUP BY
				concat(
					YEAR (r.leave_time),
					LPAD(MONTH(r.leave_time), 2, 0)
				)
		) TBR ON (
			TBR.leave_month = TBB.all_user_month
		)
	) TBL