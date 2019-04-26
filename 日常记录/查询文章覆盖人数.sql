SELECT
	count(TBC.user_id) AS cnt_user,
	TBC.article_id AS task_id,
	TBO.second_path AS org_id,
	org2. NAME AS org_name
FROM
	(
		SELECT DISTINCT
			TBA.article_id,
			TBB.user_id
		FROM
			(
				SELECT
					t.article_id,
					ao.module_id,
					substring_index(
						substring_index(ao.module_id, ',', h.id),
						',' ,- 1
					) AS module_split
				FROM
					article_rel_column t
				LEFT JOIN article_column_one ao ON (
					t.rel_column_id = ao.article_column_id
				)
				LEFT JOIN tm_city h ON (h.id - 1) <= (
					length(ao.module_id) - length(
						REPLACE (ao.module_id, ',', '')
					)
				)
				LEFT JOIN articles AT ON (t.article_id = AT .article_id)
				WHERE
					1 = 1
				AND AT .start_time >= '2019-02-01 11:32:00'
				AND AT .start_time <= '2019-04-30 11:00:00'
				AND ((t.article_id = '90000589'))
			) TBA
		LEFT JOIN (
			SELECT
				fm.source_value,
				fm.userID AS user_id
			FROM
				auth_assignment_fact_menu fm
			WHERE
				1 = 1
			AND fm.source_value IN (
				SELECT
					ao.module_id
				FROM
					article_column_one ao
				WHERE
					1 = 1
				AND ao.article_column_id IN (
					SELECT
						ar.rel_column_id
					FROM
						article_rel_column ar
					LEFT JOIN articles AT ON (
						ar.article_id = AT .article_id
					)
					WHERE
						1 = 1
					AND AT .start_time >= '2019-02-01 11:32:00'
					AND AT .start_time <= '2019-04-30 11:00:00'
					AND ((ar.article_id = '90000589'))
				)
			)
		) TBB ON (
			TBA.module_split = TBB.source_value
		)
		WHERE
			TBB.user_id IS NOT NULL
	) TBC
LEFT JOIN sys_user su ON (TBC.user_id = su.sys_user_id)
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
				AND app_id = 'cs'
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
					AND app_id = 'cs'
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
					AND app_id = 'cs'
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
					AND app_id = 'cs'
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
					AND app_id = 'cs'
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
					AND app_id = 'cs'
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
		AND app_id = 'cs'
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
			AND app_id = 'cs'
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
			AND app_id = 'cs'
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
			AND app_id = 'cs'
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
			AND app_id = 'cs'
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
			AND app_id = 'cs'
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
	TBC.article_id,
	TBO.second_path