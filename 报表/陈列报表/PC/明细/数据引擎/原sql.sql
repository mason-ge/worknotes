SELECT
	TBL.*
FROM
	(
		SELECT
			ntb.task_code,
			ntb.task_name,
			ntb.from_date AS task_from_date,
			ntb.to_date AS task_to_date,
			ntb.create_date AS task_create_date,
			o3. NAME AS area_name,
			o2. NAME AS client_name,
			o1. NAME AS store_name,
			o1.address AS store_address,
			p.param_name AS feed_area,
			(
				CASE
				WHEN f.us_flag = '0' THEN
					'不合格'
				WHEN f.us_flag = '1' THEN
					'合格'
				WHEN f.us_flag = '2' THEN
					'未指导'
				WHEN f.us_flag = '3' THEN
					'良好'
				WHEN f.us_flag = '4' THEN
					'优秀'
				WHEN f.us_flag = '5' THEN
					'差评'
				ELSE
					''
				END
			) AS us_flag,
			f.amend_ments,
			f.feedback_date,
			f.instruct_date,
			(
				CASE
				WHEN f.is_back = '0' THEN
					'否'
				WHEN f.is_back = '1' THEN
					'是'
				ELSE
					''
				END
			) AS is_back,
			(
				CASE
				WHEN f.is_adjusted = '0' THEN
					'否'
				WHEN f.is_adjusted = '1' THEN
					'是'
				ELSE
					''
				END
			) AS is_adjusted,
			su. NAME AS feedback_name,
			su.login_name AS feedback_login,
			u1.username AS auditor_name
		FROM
			feedback_detail f
		JOIN shop_feedback s ON f.sys_feedback_id = s.sys_feedback_id
		LEFT JOIN tasks ntb ON ntb.sys_task_id = s.sys_task_id
		LEFT JOIN sys_param p ON s.param_code = p.param_id
		LEFT JOIN sys_org_shop o1 ON s.org_code = o1.sys_org_id
		LEFT JOIN (
			(
				SELECT
					sys_org_id,
					NAME,
					address,
					sup_org,
					org_type,
					sup_type
				FROM
					sys_org_enterprise
				WHERE
					1 = 1
				AND delete_flag = 0
				AND app_id = 'csb'
			)
			UNION ALL
				(
					SELECT
						sys_org_id,
						NAME,
						address,
						sup_org,
						org_type,
						sup_type
					FROM
						sys_org_company
					WHERE
						1 = 1
					AND delete_flag = 0
					AND app_id = 'csb'
				)
			UNION ALL
				(
					SELECT
						sys_org_id,
						NAME,
						address,
						sup_org,
						org_type,
						sup_type
					FROM
						sys_org_agent
					WHERE
						1 = 1
					AND delete_flag = 0
					AND app_id = 'csb'
				)
			UNION ALL
				(
					SELECT
						sys_org_id,
						NAME,
						address,
						sup_org,
						org_type,
						sup_type
					FROM
						sys_org_area
					WHERE
						1 = 1
					AND delete_flag = 0
					AND app_id = 'csb'
				)
			UNION ALL
				(
					SELECT
						sys_org_id,
						NAME,
						address,
						sup_org,
						org_type,
						sup_type
					FROM
						sys_org_dep
					WHERE
						1 = 1
					AND delete_flag = 0
					AND app_id = 'csb'
				)
		) o2 ON o1.sup_org = o2.sys_org_id
		AND o1.sup_type = o2.org_type
		LEFT JOIN (
			(
				SELECT
					sys_org_id,
					NAME,
					address,
					sup_org,
					org_type
				FROM
					sys_org_enterprise
				WHERE
					1 = 1
				AND delete_flag = 0
				AND app_id = 'csb'
			)
			UNION ALL
				(
					SELECT
						sys_org_id,
						NAME,
						address,
						sup_org,
						org_type
					FROM
						sys_org_company
					WHERE
						1 = 1
					AND delete_flag = 0
					AND app_id = 'csb'
				)
			UNION ALL
				(
					SELECT
						sys_org_id,
						NAME,
						address,
						sup_org,
						org_type
					FROM
						sys_org_agent
					WHERE
						1 = 1
					AND delete_flag = 0
					AND app_id = 'csb'
				)
			UNION ALL
				(
					SELECT
						sys_org_id,
						NAME,
						address,
						sup_org,
						org_type
					FROM
						sys_org_area
					WHERE
						1 = 1
					AND delete_flag = 0
					AND app_id = 'csb'
				)
			UNION ALL
				(
					SELECT
						sys_org_id,
						NAME,
						address,
						sup_org,
						org_type
					FROM
						sys_org_dep
					WHERE
						1 = 1
					AND delete_flag = 0
					AND app_id = 'csb'
				)
		) o3 ON o2.sup_org = o3.sys_org_id
		AND o2.sup_type = o3.org_type
		LEFT JOIN (
			SELECT
				sys_user_id,
				NAME AS username
			FROM
				sys_user
		) u1 ON f.auditor = u1.sys_user_id
		LEFT JOIN sys_user su ON f.sys_user_id = su.sys_user_id
		WHERE
			1 = 1
		AND ntb.delete_flag = 0
		AND o1.app_id = 'csb'
		ORDER BY
			f.sys_feedback_id DESC
	) TBL