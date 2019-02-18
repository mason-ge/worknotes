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
	u.shop_name
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
		WHERE
			1 = 1
		AND t.del_flag = '0'
		AND e.exam_type = '3'
		AND e.del_flag = '0'
		AND T.app_id = 'csb'
		ORDER BY
			e.create_time DESC
	) TBC
LEFT JOIN sys_user u ON (
	TBC.sys_user_id = u.sys_user_id
	AND TBC.app_id = u.app_id
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