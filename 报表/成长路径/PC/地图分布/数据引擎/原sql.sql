SELECT
	TBL.*
FROM
	(
		SELECT
			count(DISTINCT t.user_id) AS cnt_people_in,
			os.latitude,
			os.longitude,
			os. NAME AS shop_name
		FROM
			growup_checkpoint_detail t
		LEFT JOIN growup_checkpoint gc ON (
			t.checkpoint_id = gc.checkpoint_id
			AND t.app_id = gc.app_id
		)
		LEFT JOIN growup_path gp ON (
			t.growup_path_id = gp.growup_path_id
			AND t.app_id = gp.growup_path_id
		)
		LEFT JOIN sys_user su ON (
			t.user_id = su.sys_user_id
			AND su.app_id = 'csb'
		)
		LEFT JOIN sys_org_shop os ON (
			su.belong_org = os.sys_org_id
			AND os.app_id = 'csb'
		)
		WHERE
			t.app_id = 'csb'
		AND t.checkpoint_flag IN ('2', '3')
		AND os.latitude IS NOT NULL
		AND os.longitude IS NOT NULL
		GROUP BY
			os.latitude,
			os.longitude,
			os. NAME
	) TBL