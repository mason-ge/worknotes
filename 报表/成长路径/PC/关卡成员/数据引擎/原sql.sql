SELECT
	TBL.*
FROM
	(
		SELECT
			t.checkpoint_name,
			gd.user_id,
			su.login_name,
			su.`name` AS user_name,
			su.shop_name,
			su.user_post AS user_post
		FROM
			(
				SELECT DISTINCT
					cp.checkpoint_id,
					cp. NAME AS checkpoint_name,
					td.growup_level_id,
					td.growup_path_id,
					cp.app_id
				FROM
					growup_checkpoint cp
				LEFT JOIN growup_checkpoint_detail td ON (
					cp.checkpoint_id = td.checkpoint_id
				)
				WHERE
					cp.app_id = 'csb'
				AND cp.delete_flag = '0'
			) t
		LEFT JOIN growup_checkpoint_detail gd ON (
			t.checkpoint_id = gd.checkpoint_id
			AND t.app_id = gd.app_id
		)
		LEFT JOIN sys_user su ON (
			su.sys_user_id = gd.user_id
			AND su.app_id = 'csb'
		)
		WHERE
			1 = 1
		GROUP BY
			t.checkpoint_name,
			gd.user_id
	) TBL