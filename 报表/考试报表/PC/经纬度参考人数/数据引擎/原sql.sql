SELECT
	TBL.*
FROM
	(
		SELECT
			os.longitude,
			os.latitude,
			su.shop_name,
			count(DISTINCT eu.sys_user_id) AS cnt_people_in
		FROM
			exam_select_user eu
		LEFT JOIN exam e ON (
			eu.app_id = e.app_id
			AND eu.exam_id = e.exam_id
		)
		LEFT JOIN sys_user su ON (
			eu.sys_user_id = su.sys_user_id
		)
		LEFT JOIN sys_org_shop os ON (
			su.belong_org = os.sys_org_id
		)
		INNER JOIN statistics s ON (
			eu.sys_user_id = s.sys_user_id
			AND eu.app_id = s.app_id
			AND eu.exam_id = s.exam_id
		)
		WHERE
			1 = 1
		AND eu.app_id = 'csb'
		AND os.longitude IS NOT NULL
		AND os.latitude IS NOT NULL
		AND eu.app_id = 'csb'
		AND e.exam_type = '3'
		AND e.app_id = 'csb'
		AND e.del_flag = '0'
		GROUP BY
			su.shop_name,
			os.longitude,
			os.latitude
	) TBL