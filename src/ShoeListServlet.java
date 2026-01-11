package chauss;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ShoeListServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String brand = request.getParameter("brand");
        String sizeStr = request.getParameter("size");
        Integer size = null;
        if (sizeStr != null && !sizeStr.isEmpty()) {
            try {
                size = Integer.parseInt(sizeStr);
            } catch (NumberFormatException e) {
                // ignore
            }
        }
        String color = request.getParameter("color");
        String type = request.getParameter("type");

        List<Shoe> shoes = ShoeData.searchShoes(brand, size, color, type);

        request.setAttribute("shoes", shoes);
        request.getRequestDispatcher("pages/listShoes.jsp").forward(request, response);
    }
}