select tbl.*
FROM
	(
		SELECT
			t.sys_user_id,
			t.login_name,
			t.belong_org,
			t. NAME AS user_name,
			TBD.path,
			t.shop_name,
			t.user_post,
			t.entry_time,
			t.create_time
		FROM
			sys_user t
		LEFT JOIN (
			SELECT
				TBC.*
			FROM
				(
					SELECT
						TBALL.sys_org_id,
						TBALL.app_id,
						GROUP_CONCAT(
							TBALL. NAME
							ORDER BY
								TBALL.row_no SEPARATOR '→'
						) AS path
					FROM
						(
							SELECT
								(@rownum := @rownum + 1) AS row_no,
								TBA.*
							FROM
								(
									SELECT
										TBLS.*, TBO. NAME
									FROM
										(
											SELECT
												t.sys_org_id,
												t.app_id,
												substring_index(
													substring_index(t.path, ',', h.id),
													',' ,- 1
												) AS path_split
											FROM
												sys_org_shop t
											LEFT JOIN tm_city h ON (h.id - 1) < (
												length(t.path) - length(REPLACE(t.path, ',', ''))
											)
											WHERE
												t.delete_flag = '0'
											AND t.app_id = 'csb'
										) TBLS
									LEFT JOIN (
										SELECT
											org.sys_org_id,
											org. NAME,
											org.app_id
										FROM
											(
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
													AND app_id = 'csb'
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
														AND app_id = 'csb'
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
														AND app_id = 'csb'
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
														AND app_id = 'csb'
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
														AND app_id = 'csb'
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
														AND app_id = 'csb'
													)
											) AS org
										WHERE
											1 = 1
									) TBO ON (
										TBLS.path_split = TBO.sys_org_id
										AND TBLS.app_id = TBO.app_id
									)
								) TBA,
								(SELECT @rownum := 0) r
						) TBALL
					GROUP BY
						TBALL.sys_org_id,
						TBALL.app_id
				) TBC
		) TBD ON (
			t.belong_org = TBD.sys_org_id
			AND t.app_id = TBD.app_id
		)
		WHERE
			1 = 1
		AND t.app_id = 'csb'
		GROUP BY
			t.sys_user_id,
			t.app_id
		ORDER BY
			t.create_time DESC
	) TBL