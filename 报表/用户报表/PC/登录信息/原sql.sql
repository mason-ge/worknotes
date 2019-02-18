SELECT
	TBL.*
FROM
	(
		SELECT
			TBT.*, TBLOG.cnt_log
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
				ul.user_id,
				ul.app_id,
				count(user_id) AS cnt_log
			FROM
				user_login_log ul
			WHERE
				1 = 1
			AND ul.app_id = 'csb'
			GROUP BY
				ul.user_id,
				ul.app_id
		) TBLOG ON (
			TBT.sys_user_id = TBLOG.user_id
			AND TBT.app_id = TBLOG.app_id
		)
	) TBL