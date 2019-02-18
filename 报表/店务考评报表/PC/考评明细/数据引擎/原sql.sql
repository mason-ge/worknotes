SELECT
	TBL.*
FROM
	(
		SELECT
			sa. NAME AS area_name,
			ss. CODE AS shop_code,
			ss. NAME AS shop_name,
			tb.task_name AS task_name,
			sp.param_name AS param_name,
			(
				CASE
				WHEN (
					fd.us_flag = '0'
					AND fd.is_back = '0'
				) THEN
					'20'
				WHEN fd.us_flag = '1' THEN
					'20'
				WHEN (
					fd.us_flag = '1'
					AND fd.is_back = '0'
				) THEN
					'60'
				WHEN (
					fd.us_flag = '3'
					AND fd.is_back = '0'
				) THEN
					'80'
				WHEN (
					fd.us_flag = '4'
					AND fd.is_back = '0'
				) THEN
					'100'
				ELSE
					'0'
				END
			) AS comment_score,
			su. NAME AS feedback_name,
			su.login_name AS feedback_login,
			su.tel AS tel,
			(
				CASE
				WHEN fd.task_id IS NULL THEN
					'未反馈'
				ELSE
					'已反馈'
				END
			) AS is_feedback,
			fd.amend_ments AS amend_ments
		FROM
			feedback_task_org ft
		LEFT JOIN new_task_basis tb ON (ft.task_id = tb.task_id)
		LEFT JOIN sys_user su ON (
			ft.sys_user_id = su.sys_user_id
		)
		LEFT JOIN feedback_detail fd ON (
			ft.task_id = fd.task_id
			AND ft.sys_user_id = fd.sys_user_id
		)
		LEFT JOIN shop_feedback sf ON (
			fd.sys_feedback_id = sf.sys_feedback_id
		)
		LEFT JOIN sys_param sp ON (
			sf.param_code = sp.param_id
			AND sp.app_id = 'csb'
		)
		LEFT JOIN sys_org_shop ss ON (
			ft.belong_org = ss.sys_org_id
			AND ss.app_id = 'csb'
		)
		LEFT JOIN sys_org_area sa ON (
			ss.sup_org = sa.sys_org_id
			AND sa.app_id = 'csb'
		)
		LEFT JOIN tasks ts ON (
			ts.sys_task_id = sf.sys_task_id
			AND ts.app_id = 'csb'
		)
		WHERE
			1 = 1
		AND ft.app_id = 'csb'
		AND tb.app_id = 'csb'
		AND tb.task_type_id = '9'
		ORDER BY
			ts.task_name,
			ss. CODE
	) TBL