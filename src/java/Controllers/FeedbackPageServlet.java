package Controllers;

import Models.FeedbackDAO;
import Models.LocalLeadersDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "FeedbackPageServlet", urlPatterns = {"/phan-anh"})
public class FeedbackPageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        FeedbackDAO feedbackDao = new FeedbackDAO();
        LocalLeadersDAO leadersDao = new LocalLeadersDAO();

        request.setAttribute("feedbackTypes", feedbackDao.getAllFeedbackTypes());
        request.setAttribute("districts", leadersDao.getDistrictWardsMap());

        request.getSession(true);
        request.getRequestDispatcher("/phan-anh.jsp").forward(request, response);
    }
}
