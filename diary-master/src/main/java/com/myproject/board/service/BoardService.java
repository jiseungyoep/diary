package com.myproject.board.service;

import java.util.List;

import com.myproject.board.vo.BoardVO;

public interface BoardService{
	
	public void write (BoardVO boardVO) throws Exception;
	
	public List<BoardVO> list(BoardVO boardVO) throws Exception;
	
	public List<BoardVO> detaillist(String bno) throws Exception;
	
	public List<BoardVO> update(BoardVO boardVO) throws Exception;
	
	public List<BoardVO> delete(String bno) throws Exception;
}