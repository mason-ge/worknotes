SELECT
	count(TBA.sys_user_id) AS cnt_user,
	TBA.act_id AS task_id,
	TBO.second_path AS org_id,
	org2. NAME AS org_name
FROM
	(
		SELECT DISTINCT
			t.act_id,
			gm.sys_user_id,
			t.app_id
		FROM
		activity_info t
		left join activity_user au ON (t.act_id = au.act_id)
		LEFT JOIN group_mem gm ON (au.group_id = gm.group_id)
		WHERE
			1 = 1
		AND (
			(t.act_id = '27998')
		)
		AND t.pub_time >= '2019-04-17 20:22:00'
		AND t.pub_time <= '2019-04-30 10:00:00'
	) TBA
LEFT JOIN sys_user su ON (
	TBA.sys_user_id = su.sys_user_id
)
LEFT JOIN (
	SELECT
		org.sys_org_id,
		SUBSTRING_INDEX(
			SUBSTRING_INDEX(org.second_path, '_', 1),
			'_',
			1
		) AS second_path,
		org.app_id
	FROM
		(
			(
				SELECT
					sys_org_id,
					SUBSTRING_INDEX(
						SUBSTRING_INDEX(path, ',', 2),
						',' ,- 1
					) AS second_path,
					app_id
				FROM
					sys_org_company
				WHERE
					1 = 1
				AND delete_flag = 0
				AND app_id = 'CS'
			)
			UNION ALL
				(
					SELECT
						sys_org_id,
						SUBSTRING_INDEX(
							SUBSTRING_INDEX(path, ',', 2),
							',' ,- 1
						) AS second_path,
						app_id
					FROM
						sys_org_agent
					WHERE
						1 = 1
					AND delete_flag = 0
					AND app_id = 'CS'
				)
			UNION ALL
				(
					SELECT
						sys_org_id,
						SUBSTRING_INDEX(
							SUBSTRING_INDEX(path, ',', 2),
							',' ,- 1
						) AS second_path,
						app_id
					FROM
						sys_org_area
					WHERE
						1 = 1
					AND delete_flag = 0
					AND app_id = 'CS'
				)
			UNION ALL
				(
					SELECT
						sys_org_id,
						SUBSTRING_INDEX(
							SUBSTRING_INDEX(path, ',', 2),
							',' ,- 1
						) AS second_path,
						app_id
					FROM
						sys_org_dep
					WHERE
						1 = 1
					AND delete_flag = 0
					AND app_id = 'CS'
				)
			UNION ALL
				(
					SELECT
						sys_org_id,
						SUBSTRING_INDEX(
							SUBSTRING_INDEX(path, ',', 2),
							',' ,- 1
						) AS second_path,
						app_id
					FROM
						sys_org_shop
					WHERE
						1 = 1
					AND delete_flag = 0
					AND app_id = 'CS'
				)
			UNION ALL
				(
					SELECT
						sys_org_id,
						SUBSTRING_INDEX(
							SUBSTRING_INDEX(path, ',', 2),
							',' ,- 1
						) AS second_path,
						app_id
					FROM
						sys_org_enterprise
					WHERE
						1 = 1
					AND delete_flag = 0
					AND app_id = 'CS'
				)
		) AS org
) TBO ON (
	TBO.sys_org_id = su.belong_org
	AND TBO.app_id = su.app_id
)
LEFT JOIN (
	(
		SELECT
			sys_org_id,
			NAME,
			app_id
		FROM
			sys_org_company
		WHERE
			1 = 1
		AND delete_flag = 0
		AND app_id = 'CS'
	)
	UNION ALL
		(
			SELECT
				sys_org_id,
				NAME,
				app_id
			FROM
				sys_org_agent
			WHERE
				1 = 1
			AND delete_flag = 0
			AND app_id = 'CS'
		)
	UNION ALL
		(
			SELECT
				sys_org_id,
				NAME,
				app_id
			FROM
				sys_org_area
			WHERE
				1 = 1
			AND delete_flag = 0
			AND app_id = 'CS'
		)
	UNION ALL
		(
			SELECT
				sys_org_id,
				NAME,
				app_id
			FROM
				sys_org_dep
			WHERE
				1 = 1
			AND delete_flag = 0
			AND app_id = 'CS'
		)
	UNION ALL
		(
			SELECT
				sys_org_id,
				NAME,
				app_id
			FROM
				sys_org_shop
			WHERE
				1 = 1
			AND delete_flag = 0
			AND app_id = 'CS'
		)
	UNION ALL
		(
			SELECT
				sys_org_id,
				NAME,
				app_id
			FROM
				sys_org_enterprise
			WHERE
				1 = 1
			AND delete_flag = 0
			AND app_id = 'CS'
		)
) org2 ON (
	TBO.second_path = org2.sys_org_id
)
WHERE
    1 = 1
AND TBO.second_path IS NOT NULL
AND TBO.second_path <> ''
AND su.work_flag = '1'
GROUP BY
	TBA.act_id,
	TBO.second_path