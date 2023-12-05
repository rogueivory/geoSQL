	/*Updates the line number on which a PO box or drawer/bin/etc. was found (if any) */	

	/* 	Originally written for use in Teradata DW */
	/*	----------------------------------------------------------------------------------
			1. REGEXP_INSTR() returns a non-null, non-zero value corresponding to the position of the first character in the sequence matching the regular expression. 
			2. SIGN() returns 0 if input value is 0, or 1 if input value is positive integer. (Effectively turning the result of REGEXP_INSTR() into a yes/no indicator). 
			3. Result is multiplied by 1 to obtain bitwise value. 2 and 4 are used for address line 2 and 3 respectively, thereby allowing multiple PO box lines to be indicated in a single bitwise value.
					Additional address lines can be considered by continuing the bitwise pattern (2^line number), e.g. line 4 = * 8, line 5 = * 16, etc.
					e.g. result (1) = bitwise 001, indicates po box on line 1,
								result (2) = bitwise 010, indicates po box on line 2, 
								result (5) = (1 * 4) + (1 * 1) = bitwise 101, indicates po box match on line 1 and 3,
								etc. 
			4 ZEROIFNULL() ensures that any NULL returns are set to 0 (i.e. no match to regexp string), so that calculations are not errored when one or more of the address lines is NULL. 

			TODO: 
				A. Pull regexp string used for match from query parameter table to allow for code maintainability. 
				B. Possibly loop query across X number of address lines, rather than stating each line explicitly. 
					b1. May cause performance issues depending on implementation. 
					b2. May also result in lower code maintainability. 
				C. Update logic to work in T-SQL / MS SQL Server
				D. Monitor overall performance, especially w/select distinct statement. 
			----------------------------------------------------------------------------------
	*/

		UPDATE address_stage
			FROM
				(	SELECT DISTINCT
						addr_lines.address_pk
						, SUM(addr_lines.po_box_ind) AS po_box_line
					FROM
						(	SELECT									
								address_load.DIM_ADDR_CK AS address_pk

								, ZEROIFNULL(SIGN(REGEXP_INSTR(address_load.address_line_1,'(\b(?:Post(?:al)? (?:Office )?|P[. ]?O\.? )?Box\b(?=.+))|(\bP[. ]?O[. ]?B[. ]?\b(?=.+))|\bDRA?WE?R\b|\bLO?CKBO?X\b|\b(FI?RM\b)?CA?LLE?R\b|\bBIN\b',1,1,0,'i')) * 1) AS po_box_ind
								
							FROM load.DIM_ADDR_STAGE_UX AS address_load
							
							UNION 
							
							SELECT									
								address_load.DIM_ADDR_CK AS address_pk
								, ZEROIFNULL(SIGN(REGEXP_INSTR(address_load.address_line_2,'(\b(?:Post(?:al)? (?:Office )?|P[. ]?O\.? )?Box\b(?=.+))|(\bP[. ]?O[. ]?B[. ]?\b(?=.+))|\bDRA?WE?R\b|\bLO?CKBO?X\b|\b(FI?RM\b)?CA?LLE?R\b|\bBIN\b',1,1,0,'i')) * 2) AS po_box_ind
								
							FROM load.DIM_ADDR_STAGE_UX AS address_load

							UNION 
							
							SELECT									
								address_load.DIM_ADDR_CK AS address_pk
								, ZEROIFNULL(SIGN(REGEXP_INSTR(address_load.address_line_3,'(\b(?:Post(?:al)? (?:Office )?|P[. ]?O\.? )?Box\b(?=.+))|(\bP[. ]?O[. ]?B[. ]?\b(?=.+))|\bDRA?WE?R\b|\bLO?CKBO?X\b|\b(FI?RM\b)?CA?LLE?R\b|\bBIN\b',1,1,0,'i')) * 4) AS po_box_ind
								
							FROM load.DIM_ADDR_STAGE_UX AS address_load

						) AS addr_lines
											
					GROUP BY addr_lines.address_pk
				) AS j_tbl
			SET po_box_line = j_tbl.po_box_line
			WHERE address_stage.address_pk = j_tbl.address_pk
						AND address_stage.po_box_line IS NULL;	