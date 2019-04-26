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
			user_login_log t FORCE INDEX (idx_op_time)
		WHERE
			1 = 1
		AND t.app_id = 'csb'
		AND t.operation_time BETWEEN date_format(
			DATE_SUB(now(), INTERVAL 6 DAY),
			'%Y-%m-%d 00:00:00'
		)
		AND date_format(now(), '%Y-%m-%d 00:00:00')
	) TBL