SELECT
	TBL.*
FROM
	(
		SELECT
			TBA.*, TBQ.exam_score,
			round(
				TBV.total_score / TBV.cnt_take,
				2
			) AS avg_score,
			q.title,
			TBD.cnt_qa,
			CONCAT(
				round(
					ifnull(TBQR.cnt_rignt, 0) / TBD.cnt_qa,
					2
				) * 100,
				'%'
			) AS accuracy_rate
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
		LEFT JOIN exam_question eq ON (eq.exam_id = TBA.exam_id)
		LEFT JOIN question q ON (
			eq.question_id = q.question_id
			AND TBA.app_id = q.app_id
		)
		LEFT JOIN (
			SELECT
				ed.question_id,
				s.exam_id,
				s.app_id,
				count(s.sid) AS cnt_qa
			FROM
				exam_detail ed
			LEFT JOIN statistics s ON (ed.statistics_id = s.sid)
			LEFT JOIN exam t ON (s.exam_id = t.exam_id)
			WHERE
				1 = 1
			AND t.exam_type = '3'
			AND t.app_id = 'csb'
			AND t.del_flag = '0'
			GROUP BY
				ed.question_id,
				s.exam_id,
				s.app_id
		) TBD ON (
			TBD.app_id = TBA.app_id
			AND TBD.exam_id = eq.exam_id
			AND TBD.question_id = eq.question_id
		)
		LEFT JOIN (
			SELECT
				TBED.exam_id,
				TBED.app_id,
				TBED.question_id,
				count(TBED.ed_id) AS cnt_rignt
			FROM
				(
					SELECT
						s.exam_id,
						s.app_id,
						ed.question_id,
						ed.ed_id,
						length(ed.answer_id) - length(
							REPLACE (ed.answer_id, ',', '')
						) AS answer_num,
						length(qs.rights) - length(REPLACE(qs.rights, ',', '')) AS rights_num
					FROM
						exam_detail ed
					LEFT JOIN statistics s ON (s.sid = ed.statistics_id)
					LEFT JOIN exam t ON (s.exam_id = t.exam_id)
					LEFT JOIN question qs ON (
						ed.question_id = qs.question_id
					)
					WHERE
						1 = 1
					AND ed.answer_id IS NOT NULL
					AND ed.answer_id <> ''
					AND qs.rights IS NOT NULL
					AND qs.rights <> ''
					AND t.exam_type = '3'
					AND t.app_id = 'csb'
					AND t.del_flag = '0'
				) TBED
			WHERE
				TBED.answer_num = TBED.rights_num
			GROUP BY
				TBED.exam_id,
				TBED.app_id,
				TBED.question_id
		) TBQR ON (
			TBQR.app_id = TBA.app_id
			AND TBQR.exam_id = eq.exam_id
			AND TBQR.question_id = eq.question_id
		)
	) TBL