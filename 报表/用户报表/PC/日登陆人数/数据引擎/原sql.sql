SELECT
	TBL.*
FROM
	(
		SELECT
			count(DISTINCT t.user_id) AS cnt_today_log
		FROM
			user_login_log t
		WHERE
			1 = 1
		AND t.app_id = 'csb'
		AND T.operation_time >= date_format(now(), '%Y-%m-%d 00:00:00')
		AND T.operation_time <= date_format(now(), '%Y-%m-%d 23:00:00')
	) TBL