SELECT
	TBL.*
FROM
	(
		SELECT
			TBA.*, TBQ.exam_score,

		IF (
			TBCP.cnt_take > 0,
			'已考',
			'未考'
		) AS take_flg,

	IF (
		TBCP.cnt_pass > 0,
		'已通过',
		'未通过'
	) AS pass_flg,
	TBCP.cnt_take,
	TBCP.max_score,
	TBCP.total_use_time
FROM
	(
		SELECT
			t.exam_code,
			t.exam_id,
			t.app_id,
			t.exam_title,
			(
				CASE
				WHEN t.exam_species = '1' THEN
					'正式考试'
				WHEN t.exam_species = '2' THEN
					'模拟考试'
				WHEN t.exam_species = '3' THEN
					'开单练习'
				WHEN t.exam_species = '4' THEN
					'打字练习'
				ELSE
					''
				END
			) AS exam_species,
			(
				CASE
				WHEN t. STATUS = '0' THEN
					'未发布'
				WHEN t. STATUS = '1' THEN
					'已发布'
				WHEN t. STATUS = '2' THEN
					'已完成'
				WHEN t. STATUS = '3' THEN
					'关闭'
				ELSE
					''
				END
			) AS exam_status,
			t.start_time,
			t.end_time,
			t.create_user,
			t.create_time,
			u.sys_user_id,
			u. NAME AS user_name,
			u.login_name,
			u.user_post
		FROM
			exam t
		LEFT JOIN exam_select_user eu ON (
			eu.exam_id = t.exam_id
			AND eu.app_id = t.app_id
		)
		LEFT JOIN sys_user u ON (
			eu.sys_user_id = u.sys_user_id
			AND t.app_id = u.app_id
		)
		WHERE
			1 = 1
		AND t.app_id = 'csb'
		AND t.exam_type = '3'
		AND t.del_flag = '0'
		ORDER BY
			t.create_time DESC
	) TBA
LEFT JOIN (
	SELECT
		eq.exam_id,
		sum(eq.score) AS exam_score
	FROM
		exam_question eq
	LEFT JOIN exam t ON (eq.exam_id = t.exam_id)
	WHERE
		1 = 1
	AND t.exam_type = '3'
	AND t.app_id = 'csb'
	AND t.del_flag = '0'
	GROUP BY
		eq.exam_id
) TBQ ON (TBA.exam_id = TBQ.exam_id)
LEFT JOIN (
	SELECT
		s.sys_user_id,
		s.app_id,
		s.exam_id,
		count(1) AS cnt_take,
		max(s.score) AS max_score,
		count(
			CASE
			WHEN s.exam_pass_type = '9' THEN
				s.sid
			ELSE
				NULL
			END
		) AS cnt_pass,
		sum(s.use_time) AS total_use_time
	FROM
		statistics s
	LEFT JOIN exam t ON (s.exam_id = t.exam_id)
	WHERE
		1 = 1
	AND t.exam_type = '3'
	AND t.app_id = 'csb'
	AND t.del_flag = '0'
	GROUP BY
		s.sys_user_id,
		s.app_id,
		s.exam_id
) TBCP ON (
	TBCP.sys_user_id = TBA.sys_user_id
	AND TBCP.app_id = TBA.app_id
	AND TBCP.exam_id = TBA.exam_id
)
	) TBL