package com.koreait.www.repository;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

public interface LikeMapper {

    @Insert("INSERT INTO tbl_like (bno, liker) VALUES (#{bno}, #{liker})")
    int insert(@Param("bno") Long bno, @Param("liker") String liker);

    @Delete("DELETE FROM tbl_like WHERE bno = #{bno} AND liker = #{liker}")
    int delete(@Param("bno") Long bno, @Param("liker") String liker);

    @Select("SELECT count(*) FROM tbl_like WHERE bno = #{bno} AND liker = #{liker}")
    int checkLike(@Param("bno") Long bno, @Param("liker") String liker);
    
    // Board 테이블의 like_count 업데이트
    @Update("UPDATE board SET like_count = like_count + 1 WHERE bno = #{bno}")
    void increaseLikeCount(Long bno);
    
    @Update("UPDATE board SET like_count = like_count - 1 WHERE bno = #{bno}")
    void decreaseLikeCount(Long bno);
}
