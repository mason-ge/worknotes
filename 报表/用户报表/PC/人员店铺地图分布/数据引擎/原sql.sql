SELECT
	TBL.*
FROM
	(
		SELECT
			os.longitude,
			os.latitude,
			t.shop_name,
			count(DISTINCT t.sys_user_id) AS cnt_people_in
		FROM
			sys_user t
		LEFT JOIN sys_org_shop os ON (
			t.belong_org = os.sys_org_id
			AND t.app_id = os.app_id
		)
		WHERE
			1 = 1
		AND t.app_id = 'csb'
		AND os.longitude IS NOT NULL
		AND os.latitude IS NOT NULL
		GROUP BY
			t.shop_name,
			os.longitude,
			os.latitude
	) TBL