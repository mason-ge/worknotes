SELECT
	TBL.*
FROM
	(
		SELECT
			count(DISTINCT t.user_id) AS cnt_today_user,
			(
				SELECT
					count(1)
				FROM
					sys_user s
				WHERE
					s.create_time IS NOT NULL
				AND s.app_id = 'csb'
			) AS cnt_all_user
		FROM
			user_login_log t
		WHERE
			DATE(t.operation_time) <= DATE(CURDATE())
		AND DATE(t.operation_time) >= DATE_SUB(CURDATE(), INTERVAL 6 DAY)
		AND t.app_id = 'csb'
	) TBL