SELECT
	TBL.*
(
		SELECT
			os.longitude,
			os.latitude,
			t.shop_name,
			count(DISTINCT le.lecturer_user_id) AS cnt_people_in
		FROM 
			lecture_lecturer le
		inner join 
			sys_user t ON (le.lecturer_user_id = t.sys_user_id and le.app_id = t.app_id)
		LEFT JOIN sys_org_shop os ON (
			t.belong_org = os.sys_org_id
			AND t.app_id = os.app_id
		)
		WHERE
			1 = 1
		AND le.app_id = 'csb'
		AND le.STATUS <> 3
		AND os.longitude IS NOT NULL
		AND os.latitude IS NOT NULL
		GROUP BY
			t.shop_name,
			os.longitude,
			os.latitude
	) TBL