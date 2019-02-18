SELECT
	TBL.*
FROM
	(
		SELECT
			TBA.*, ss. CODE AS shop_code,
			ss. NAME AS shop_name,
			sa. NAME AS area_name
		FROM
			(
				SELECT
					t.task_code,
					t.task_id,
					t.task_name,
					su. NAME AS feedback_name,
					su.sys_user_id,
					su.login_name AS feedback_login,
					su.belong_org,
					t.create_date AS task_create_date,
					TBF.feedback_date,
					(
						CASE
						WHEN TBF.task_id IS NULL THEN
							'未反馈'
						ELSE
							'已反馈'
						END
					) AS is_feedback,
					round(
						(
							UNIX_TIMESTAMP(TBF.feedback_date) - UNIX_TIMESTAMP(t.publish_time)
						) / (60 * 60),
						0
					) AS diff_hour
				FROM
					new_task_basis t
				LEFT JOIN new_task_user_detail td ON (
					t.task_id = td.task_id
					AND td.del_flag = '0'
					AND td.app_id = 'csb'
				)
				LEFT JOIN sys_user su ON (
					td.sys_user_id = su.sys_user_id
				)
				LEFT JOIN feedback_task_org fo ON (
					fo.task_id = t.task_id
					AND fo.sys_user_id = td.sys_user_id
					AND fo.app_id = 'csb'
				)
				LEFT JOIN (
					SELECT
						fd.task_id,
						fd.sys_user_id,
						max(fd.feedback_date) AS feedback_date
					FROM
						feedback_detail fd
					GROUP BY
						fd.task_id,
						fd.sys_user_id
				) TBF ON (
					fo.task_id = TBF.task_id
					AND fo.sys_user_id = TBF.sys_user_id
				)
				WHERE
					1 = 1
				AND t.app_id = 'csb'
				AND t.task_type_id = '9'
				AND t.create_task_from <> '1'
				ORDER BY
					t.task_code DESC
				LIMIT 3000
			) TBA
		LEFT JOIN sys_org_shop ss ON (
			TBA.belong_org = ss.sys_org_id
			AND ss.app_id = 'csb'
		)
		LEFT JOIN sys_org_area sa ON (
			ss.sup_org = sa.sys_org_id
			AND sa.app_id = 'csb'
		)
		WHERE
			1 = 1
	) TBL