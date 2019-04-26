SELECT
	TBL.*
FROM
	(
		SELECT
			TBC.*,
		IF (
			TBCP.cnt_take > 0,
			'已考',
			'未考'
		) AS take_flg,
		u.login_name,
		u. NAME AS user_name,

	IF (
		TBCP.cnt_pass > 0,
		'已通过',
		'未通过'
	) AS pass_flg,
	TBCP.cnt_take AS cnt_take,
	TBCP.max_score AS max_score,
	TBCP.avg_score AS avg_score,
	u.user_post,
	TBO.org_code,
	TBO.org_name,

IF (
	u.org_type = '5',
	os.nature,
	'-'
) AS nature
FROM
	(
		SELECT
			t.sys_user_id,
			t.app_id,
			e.exam_title,
			e.exam_id,
			(
				CASE
				WHEN e.exam_species = '1' THEN
					'正式考试'
				WHEN e.exam_species = '2' THEN
					'模拟考试'
				WHEN e.exam_species = '3' THEN
					'开单练习'
				WHEN e.exam_species = '4' THEN
					'打字练习'
				ELSE
					''
				END
			) AS exam_species,
			e.start_time,
			e.create_time
		FROM
			exam_select_user t
		LEFT JOIN exam e ON (
			t.exam_id = e.exam_id
			AND t.app_id = e.app_id
		)
		LEFT JOIN sys_user su ON (
			su.sys_user_id = '@##org_user_id##@'
		)
		LEFT JOIN sys_user su2 ON (
			su2.sys_user_id = t.sys_user_id
			AND su2.app_id = t.app_id
		)
		WHERE
			1 = 1
		AND t.del_flag = '0'
		AND e.exam_type = '3'
		AND e.del_flag = '0'
		AND t.app_id = 'csb'
		AND e.app_id = 'csb'
		ORDER BY
			e.create_time DESC
	) TBC
LEFT JOIN sys_user u ON (
	TBC.sys_user_id = u.sys_user_id
	AND TBC.app_id = u.app_id
)
LEFT JOIN sys_org_shop os ON (
	u.belong_org = os.sys_org_id
	AND u.app_id = os.app_id
)
LEFT JOIN (
	SELECT
		org.sys_org_id,
		org. CODE AS org_code,
		org. NAME AS org_name,
		org.app_id
	FROM
		(
			(
				SELECT
					sys_org_id,
					CODE,
					NAME,
					app_id
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
						CODE,
						NAME,
						app_id
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
						CODE,
						NAME,
						app_id
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
						CODE,
						NAME,
						app_id
					FROM
						sys_org_dep
					WHERE
						1 = 1
					AND delete_flag = 0
					AND app_id = 'csb'
				)
			UNION ALL
				(
					SELECT
						sys_org_id,
						CODE,
						NAME,
						app_id
					FROM
						sys_org_shop
					WHERE
						1 = 1
					AND delete_flag = 0
					AND app_id = 'csb'
				)
			UNION ALL
				(
					SELECT
						sys_org_id,
						CODE,
						NAME,
						app_id
					FROM
						sys_org_enterprise
					WHERE
						1 = 1
					AND app_id = 'csb'
				)
		) org
) TBO ON (
	TBO.sys_org_id = u.belong_org
	AND TBO.app_id = u.app_id
)
LEFT JOIN (
	SELECT
		s.sys_user_id,
		s.app_id,
		s.exam_id,
		count(1) AS cnt_take,
		max(s.score) AS max_score,
		AVG(s.score) AS avg_score,
		count(
			CASE
			WHEN s.exam_pass_type = '9' THEN
				s.sid
			ELSE
				NULL
			END
		) AS cnt_pass
	FROM
		statistics s
	LEFT JOIN exam e ON (s.exam_id = e.exam_id)
	WHERE
		1 = 1
	AND e.exam_type = '3'
	AND e.del_flag = '0'
	AND e.app_id = 'csb'
	GROUP BY
		s.sys_user_id,
		s.app_id,
		s.exam_id
) TBCP ON (
	TBCP.sys_user_id = TBC.sys_user_id
	AND TBCP.app_id = TBC.app_id
	AND TBC.exam_id = TBCP.exam_id
)
	) TBL