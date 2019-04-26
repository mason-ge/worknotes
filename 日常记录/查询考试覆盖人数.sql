SELECT
	count(TBA.sys_user_id) AS cnt_user,
	TBA.exam_id AS task_id,
	TBO.second_path AS org_id,
	org2. NAME AS org_name
FROM
	(
		SELECT DISTINCT
			t.exam_id,
			eu.sys_user_id
		FROM
			exam t
		LEFT JOIN exam_select_user eu ON (t.exam_id = eu.exam_id)
		WHERE
			1 = 1
		AND (
			(t.exam_id = '3839705')
		
		)
		AND t.start_time >= '2018-04-17 20:22:00'
		AND t.start_time <= '2019-04-30 10:00:00'
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
	TBA.exam_id,
	TBO.second_path