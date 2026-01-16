import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class ClientLoginServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/pages/loginClient.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        // Default testing credentials (always accepted)
        if(email != null && password != null) {
            if("testclient@gmail.com".equalsIgnoreCase(email) && "1234".equals(password)){
                HttpSession s = req.getSession(true);
                s.setAttribute("email", email);
                s.setAttribute("role", "client");
                resp.sendRedirect(req.getContextPath() + "/shoes");
                return;
            }
        }
        req.setAttribute("error", "Identifiants invalides");
        req.getRequestDispatcher("/pages/loginClient.jsp").forward(req, resp);
    }
}
