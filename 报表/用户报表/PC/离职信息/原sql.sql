SELECT
	TBL.*
FROM
	(
		SELECT
			TBT.*, TBR.leave_time
		FROM
			(
				SELECT
					t.sys_user_id,
					t.login_name,
					t. NAME AS user_name,
					t.belong_org,
					t.shop_name,
					t.create_time,
					t.entry_time,
					t.app_id
				FROM
					sys_user t
				WHERE
					1 = 1
				AND t.app_id = 'csb'
				ORDER BY
					t.create_time DESC
			) TBT
		LEFT JOIN (
			SELECT
				r.user_id,
				r.app_id,
				max(r.leave_time) AS leave_time
			FROM
				sys_user_leave_report r
			WHERE
				r.app_id = 'csb'
			GROUP BY
				r.user_id,
				r.app_id
		) TBR ON (
			TBT.sys_user_id = TBR.user_id
			AND TBT.app_id = TBR.app_id
		)
	) TBL