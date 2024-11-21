import Newsletter from "../components/Newsletter";
import CoursesSection from "../components/CoursesSection";
import HeroSection from "../components/HeroSection";
import InstructorsSection from "../components/InstructorsSection";

function Home() {
    return (
        <div>
            <HeroSection />
            <CoursesSection />
            <InstructorsSection />
            <Newsletter />
        </div>
    );
}

export default Home;
