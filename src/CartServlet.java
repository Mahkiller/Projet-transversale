import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;
import java.util.HashMap;

public class CartServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // forward to panier.jsp for viewing
        req.getRequestDispatcher("/pages/panier.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action") != null ? req.getParameter("action") : "add";
        HttpSession session = req.getSession(true);
        @SuppressWarnings("unchecked")
        Map<Integer,Integer> cart = (Map<Integer,Integer>) session.getAttribute("cart");
        if (cart == null) { cart = new HashMap<>(); session.setAttribute("cart", cart); }

        if("add".equalsIgnoreCase(action)){
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                int qty = 1;
                try { qty = Integer.parseInt(req.getParameter("qty")); } catch(Exception e) { qty = 1; }
                cart.put(id, cart.getOrDefault(id,0) + Math.max(1, qty));
            } catch(Exception ignored) {}
        } else if("remove".equalsIgnoreCase(action)){
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                cart.remove(id);
            } catch(Exception ignored) {}
        } else if("update".equalsIgnoreCase(action)){
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                int qty = Integer.parseInt(req.getParameter("qty"));
                if(qty > 0) cart.put(id, qty); else cart.remove(id);
            } catch(Exception ignored) {}
        } else if("clear".equalsIgnoreCase(action)){
            cart.clear();
        }

        // after mutation redirect to cart view
        resp.sendRedirect(req.getContextPath() + "/cart");
    }
}
