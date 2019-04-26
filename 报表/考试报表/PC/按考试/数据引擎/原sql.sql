SELECT
	TBL.*
FROM
	(
		SELECT
			TBA.*, TBQ.exam_score,
			TBP.cnt_people,
			TBPI.cnt_people_in,
			round(
				TBV.total_score / TBV.cnt_take,
				2
			) AS avg_score,
			TBF.cnt_full
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
					t.create_time
				FROM
					exam t
				WHERE
					1 = 1
				AND t.app_id = 'csb'
				AND t.exam_type = '3'
				AND t.del_flag = '0'
				AND t.exam_id IN (
					SELECT
						es.exam_id
					FROM
						exam_select_user es
					WHERE
						1 = 1
					AND es.app_id = 'csb'
				)
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
				eu.app_id,
				eu.exam_id,
				count(DISTINCT eu.sys_user_id) AS cnt_people
			FROM
				exam_select_user eu
			WHERE
				1 = 1
			AND eu.app_id = 'csb'
			GROUP BY
				eu.app_id,
				eu.exam_id
		) TBP ON (
			TBP.app_id = TBA.app_id
			AND TBP.exam_id = TBA.exam_id
		)
		LEFT JOIN (
			SELECT
				eu.app_id,
				eu.exam_id,
				count(DISTINCT eu.sys_user_id) AS cnt_people_in
			FROM
				exam_select_user eu
			INNER JOIN statistics s ON (
				eu.sys_user_id = s.sys_user_id
				AND eu.exam_id = s.exam_id
			)
			LEFT JOIN exam t ON (s.exam_id = t.exam_id)
			WHERE
				1 = 1
			AND eu.app_id = 'csb'
			AND t.exam_type = '3'
			AND t.app_id = 'csb'
			AND t.del_flag = '0'
			GROUP BY
				eu.app_id,
				eu.exam_id
		) TBPI ON (
			TBPI.app_id = TBA.app_id
			AND TBPI.exam_id = TBA.exam_id
		)
		LEFT JOIN (
			SELECT
				s.exam_id,
				s.app_id,
				sum(s.score) AS total_score,
				count(1) AS cnt_take
			FROM
				statistics s
			LEFT JOIN exam t ON (s.exam_id = t.exam_id)
			WHERE
				1 = 1
			AND t.exam_type = '3'
			AND t.app_id = 'csb'
			AND t.del_flag = '0'
			GROUP BY
				s.exam_id,
				s.app_id
		) TBV ON (
			TBV.app_id = TBA.app_id
			AND TBV.exam_id = TBA.exam_id
		)
		LEFT JOIN (
			SELECT
				TBE.exam_id,
				TBE.app_id,
				count(DISTINCT TBE.sys_user_id) AS cnt_full
			FROM
				(
					SELECT
						s.exam_id,
						s.sys_user_id,
						s.app_id,
						length(ed.answer_id) - length(
							REPLACE (ed.answer_id, ',', '')
						) AS answer_num,
						length(ed.rights) - length(REPLACE(ed.rights, ',', '')) AS rights_num
					FROM
						statistics s
					LEFT JOIN exam_detail ed ON (s.sid = ed.statistics_id)
					LEFT JOIN exam t ON (s.exam_id = t.exam_id)
					WHERE
						1 = 1
					AND ed.answer_id IS NOT NULL
					AND ed.answer_id <> ''
					AND ed.rights IS NOT NULL
					AND ed.rights <> ''
					AND t.exam_type = '3'
					AND t.app_id = 'csb'
					AND t.del_flag = '0'
				) TBE
			WHERE
				TBE.answer_num = TBE.rights_num
			GROUP BY
				TBE.exam_id,
				TBE.app_id
		) TBF ON (
			TBA.exam_id = TBF.exam_id
			AND TBA.app_id = TBF.app_id
		)
	) TBL