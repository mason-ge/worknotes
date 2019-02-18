SELECT
	TBL.*
FROM
	(
		SELECT
			count(DISTINCT t.user_id) AS cnt_today_log,
			(
				SELECT
					count(DISTINCT t1.sys_user_id)
				FROM
					sys_user t1
				WHERE
					t1.app_id = 'csb'
			) AS cnt_all_log
		FROM
			user_login_log t
		WHERE
			DATE(t.operation_time) = DATE(SYSDATE())
		AND t.app_id = 'csb'
	) TBL