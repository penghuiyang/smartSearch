package com.ajax;

import java.io.IOException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;

/**
 * Servlet implementation class searchServlet
 */
@WebServlet("/search")
public class searchServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	// ����
	static String keyList;
	static Set<String> datas = new HashSet<String>();

	// ��ȡ��������
	public List<String> getData(String keyword) {
		List<String> raData = new ArrayList<String>();
		for (String rd : datas) {
			if (rd.contains(keyword)) {
				raData.add(rd);
			}
		}
		return raData;
	}

	public searchServlet() {
	}

	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		// ���ñ��뼯
		req.setCharacterEncoding("utf-8");
		resp.setContentType("text/html;charset=utf-8");
		String keyword;

		keyword = req.getParameter("keyword");

		// System.out.println(keyword);

		// ��cookie�е�������е�ֵ��ӽ�datas
		Cookie cookies[] = req.getCookies();
		if (cookies != null && cookies.length > 0) {
			for (Cookie c : cookies) {
				if (c.getName().equals("keywords")) {
					String arr[] = URLDecoder.decode(c.getValue(), "utf-8")
							.split(",");
					for (String s : arr) {
						datas.add(s);
					}
					break;
				}
			}
		}

		// ��������е����ݼ��뵽cookie��
		keyList += keyword + ",";
		Cookie key = new Cookie("keywords", URLEncoder.encode(keyList, "utf-8"));
		// System.out.println(keyList);
		resp.addCookie(key);

		// System.out.println(req.getCookies()[1].getValue());

		// �õ���������
		List<String> resultList;
		try {
			resultList = getData(keyword);
		} catch (NullPointerException e) {
			resultList = getData("");
			System.out.println("û��ȡ��keyword");
		}
		List<String> result = new ArrayList<String>();
		// ������>4ֻ��ʾǰ�ĸ�����
		if (resultList.size() > 4) {
			result = resultList.subList(0, 4);
		} else {
			result = resultList;
		}
		// System.out.println(datas);
		datas.clear();
		// resp.getWriter().write(result.toString());
		resp.getWriter().write(JSONArray.fromObject(result).toString());
	}

}
